package org.pgist.tests;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.loader.AntClassLoader2;
import org.apache.tools.ant.taskdefs.MatchingTask;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.pgist.ddl.SystemHandler;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.FileSystemXmlApplicationContext;
import org.springframework.orm.hibernate3.LocalSessionFactoryBean;
import org.springframework.orm.hibernate3.SessionFactoryUtils;
import org.springframework.orm.hibernate3.SessionHolder;
import org.springframework.transaction.support.TransactionSynchronizationManager;


/**
 * Init the PGIST system
 * @author kenny
 *
 */
public class SystemInit extends MatchingTask {
    
    
    private String action = "createdb";
    
    private String configPath;
    
    private File dataPath;
    
    private ApplicationContext appContext = null;
    
    private SessionFactory sessionFactory = null; 
    
    Session session = null;
    
    Map roleMap = new HashMap();
    
    Map userMap = new HashMap();
    
    
    public void setAction(String action) {
        this.action = action;
    }


    public void setConfigPath(String configPath) {
        this.configPath = configPath;
    }


    public void setDataPath(String dataPath) {
        this.dataPath = new File(dataPath);
    }


    private boolean setUp() throws Exception {
        //code to handle cnf issues with taskdef classloader
        AntClassLoader2 antClassLoader = null;
        Object obj = this.getClass().getClassLoader();
        if (obj instanceof AntClassLoader2) {
            antClassLoader = (AntClassLoader2) obj;
            antClassLoader.setThreadContextLoader();
        }
        //end code to handle classnotfound issue

        appContext = new FileSystemXmlApplicationContext(
            new String[] {
                configPath + "/context-database.xml",
                configPath + "/context-system.xml",
                configPath + "/context-webservice.xml",
                configPath + "/context-workflow.xml",
                configPath + "/context-cvo.xml",
                configPath + "/context-pgames.xml",
            }
        );
        
        LocalSessionFactoryBean slfb = (LocalSessionFactoryBean) appContext.getBean("&sessionFactory");
        if ("createdb".equalsIgnoreCase(action)) {
            slfb.dropDatabaseSchema();
            slfb.createDatabaseSchema();
        } else if ("restoredb".equalsIgnoreCase(action)) {
            slfb.dropDatabaseSchema();
            slfb.createDatabaseSchema();
        } else if ("updatedb".equalsIgnoreCase(action)) {
            slfb.updateDatabaseSchema();
            return false;
        }
        
        sessionFactory = (SessionFactory) appContext.getBean("sessionFactory");
        session = SessionFactoryUtils.getSession(sessionFactory, true);
        TransactionSynchronizationManager.bindResource(sessionFactory, new SessionHolder(session));
        
        return true;
    }//setUp()
    
    
    protected void tearDown() throws Exception {
        SessionHolder sessionHolder = (SessionHolder) TransactionSynchronizationManager.unbindResource(sessionFactory);
        //sessionHolder.getSession().close();
        SessionFactoryUtils.releaseSession(sessionHolder.getSession(), sessionFactory);
    }//tearDown()
    
    
    /**
     * Execute the task
     */
    public void execute() throws BuildException {
        try {
            //setup hibernate and spring
            if (setUp()) {
                Transaction tx = null;
                try {
                    tx = session.beginTransaction();
                    
                    SystemHandler handler = new SystemHandler(session, dataPath, "handlers.xml");
                    
                    if ("backup".equalsIgnoreCase(action)) {
                        handler.exports(null);
                        System.out.println("PGIST database is succesfully exported to directory: "+dataPath);
                    } else {
                        handler.imports(null);
                    }
                    
                    tx.commit();
                } catch(Exception e) {
                    tx.rollback();
                    throw e;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new BuildException(e);
        } finally {
            try {
                tearDown();
            } catch(Exception e) {
                e.printStackTrace();
            }
        }
    }//execute()
    
    
    /*
    
    private void initWorkflow() throws Exception {
        File file = new File(dataPath, "pgames.xml");
        engine.addPGames(new FileInputStream(file));
        file = new File(dataPath, "templates.xml");
        engine.addTemplates(new FileInputStream(file));
    }//initWorkflow()
    
    */
    

}//class SystemInit
