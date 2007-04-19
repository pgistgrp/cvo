package org.pgist.system;

import java.util.Collection;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.pgist.funding.UserTaxInfoDTO;
import org.pgist.users.User;
import org.pgist.users.Vehicle;
import org.pgist.util.PageSetting;
import org.pgist.web.DelegatingHttpServletRequestWrapper;


/**
 * 
 * @author kenny
 *
 */
public interface RegisterService {

	Long addUser(String firstname, String lastname, String email1,  String address1, String address2, String city, String state, String zipcode, String username, String password1) throws Exception;
	
	boolean createQuotaQualify(Long id) throws Exception;
	
	void login(HttpServletRequest request, Long id) throws Exception;
	
	void addQuotaInfo(String user_interview, String user_observation) throws Exception;
	
	void addConsent() throws Exception;
	
	void deleteUser() throws Exception;
	
	
}
