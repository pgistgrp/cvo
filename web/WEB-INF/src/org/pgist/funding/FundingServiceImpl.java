package org.pgist.funding;

import java.util.Collection;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

import org.pgist.users.User;
import org.pgist.users.UserInfo;
import org.pgist.users.Vehicle;


/**
 * 
 * @author kenny
 *
 */
public class FundingServiceImpl implements FundingService {
    
    public static final float OFF_PEAK_USAGE = 0.8f;
    public static final float PEAK_USAGE = 0.2f;
    public static final float NO_CAR_FACTOR = 0.3f;    
    public static final int WEEKS_IN_YEAR = 52;
    public static final float DEFAULT_GAS_COST = 2.85f;
	
    private FundingDAO fundingDAO;
    
    
    public void setFundingDAO(FundingDAO fundingDAO) {
        this.fundingDAO = fundingDAO;
    }

	public User getUser(UserInfo userInfo) throws Exception {
		return this.fundingDAO.getUserById(userInfo.getId());
	}
    
	/**
	 * Forms a commute object from the user
	 * 
	 * @param	user	The user to base the commute off of
	 * @return	A commute object depicting the users commute
	 */
	public UserTaxInfoDTO createCommute(UserTaxInfoDTO user) throws InvalidZipcodeException, Exception {

		//Save the user object
		User tempUser = this.updateUserTaxInfo(user);
		
		//Get the users last commute object
		
		UserCommute commute = tempUser.getUserCommute();
				
		//If its null then create one and assign it to the user		
		if(commute == null) {
			commute = new UserCommute();
			tempUser.setUserCommute(commute);
			this.fundingDAO.save(commute);
			this.fundingDAO.save(tempUser);
		}
		
		String zipcode = user.getZipcode();
		
		//Check for a valid zipcode
		try {
			int tempZip = Integer.parseInt(zipcode);
			if(tempZip < 98001 || tempZip > 98940) {
				throw new InvalidZipcodeException("Zipcode of [" + zipcode + "] outside the range of the calculator");				
			}
		} catch (NumberFormatException e) {
			throw new InvalidZipcodeException("Zipcode of [" + zipcode + "] is not a valid number");
		}
		
		ZipCodeFactor zcf = this.fundingDAO.getZipCodeFactorByZipCode(zipcode);
		
		float carFactor = 1;
		if(user.getVehicles().size() == 0) {
			carFactor = NO_CAR_FACTOR;
		}
		int driveAlone = user.getDriveDays();
		int carpool = user.getCarpoolDays();
		int numPassengers = user.getCarpoolPeople();		
		
		//If no user tolls exist, then create them and assign them to the user
//		if(commute.getTolls().size() == 0) {
		//TODO Delete all the old tolls, or replace them with the new tolls
			Iterator<UserFundingSourceToll> i = user.getTolls().iterator();
			while(i.hasNext()) {
				setTripRates(i.next(), zcf, carFactor, driveAlone, carpool, numPassengers);
			}						
//		} else {
//			//If they do exist, then walk through each and see if its change, if it has, then reset it						
//		}
				
		//Include the gas cost
		ZipCodeGas gasZip = this.fundingDAO.getZipCodeGasByZipCode(zipcode);
		if(gasZip == null) {
			commute.setCostPerGallon(DEFAULT_GAS_COST);
		} else {
			commute.setCostPerGallon(gasZip.getAvgGas());			
		}
		
		//Include the annual consumption for the sales tax
		Consumption con = this.fundingDAO.getConsumptionByIncome(user.getIncome());
		commute.setAnnualConsume(con.getConsumption(user.getFamilyCount()));
		
		//Save the commute
		this.fundingDAO.save(commute);
		
		user.loadWithCommuteInfo(commute);
		return user;
	}
	
	/**
	 * Sets the trip rates for the toll
	 * 
	 * @param	toll	The funding toll source
	 */
	private void setTripRates(UserFundingSourceToll toll, ZipCodeFactor zcf, float carFactor, int driveAlone, int carpool, int numPassengers) {
		if(toll.getName().equals(UserFundingSourceToll.PARKING_DOWNTOWN)) {
			toll.setPeakTrips(calcPeakHours(zcf.getParking(), carFactor, driveAlone, carpool, numPassengers, toll.isUsed()));
			toll.setOffPeakTrips(calcOffPeakHours(zcf.getParking(), carFactor, toll.isUsed()));
		} else if(toll.getName().equals(UserFundingSourceToll.ALASKA_WAY_VIADUCT)) {
			toll.setPeakTrips(calcPeakHours(zcf.getSR99(), carFactor, driveAlone, carpool, numPassengers, toll.isUsed()));
			toll.setOffPeakTrips(calcOffPeakHours(zcf.getSR99(), carFactor, toll.isUsed()));
		} else if(toll.getName().equals(UserFundingSourceToll.I405N)) {
			toll.setPeakTrips(calcPeakHours(zcf.getI405N(), carFactor, driveAlone, carpool, numPassengers, toll.isUsed()));
			toll.setOffPeakTrips(calcOffPeakHours(zcf.getI405N(), carFactor, toll.isUsed()));
		} else if(toll.getName().equals(UserFundingSourceToll.I405S)) {
			toll.setPeakTrips(calcPeakHours(zcf.getI405S(), carFactor, driveAlone, carpool, numPassengers, toll.isUsed()));
			toll.setOffPeakTrips(calcOffPeakHours(zcf.getI405S(), carFactor, toll.isUsed()));
		} else if(toll.getName().equals(UserFundingSourceToll.SR520)) {
			toll.setPeakTrips(calcPeakHours(zcf.getSR520(), carFactor, driveAlone, carpool, numPassengers, toll.isUsed()));
			toll.setOffPeakTrips(calcOffPeakHours(zcf.getSR520(), carFactor, toll.isUsed()));
		} else if(toll.getName().equals(UserFundingSourceToll.I90)) {
			toll.setPeakTrips(calcPeakHours(zcf.getI90(), carFactor, driveAlone, carpool, numPassengers, toll.isUsed()));
			toll.setOffPeakTrips(calcOffPeakHours(zcf.getI90(), carFactor, toll.isUsed()));
		} else if(toll.getName().equals(UserFundingSourceToll.SR167)) {
			toll.setPeakTrips(calcPeakHours(zcf.getSR167(), carFactor, driveAlone, carpool, numPassengers, toll.isUsed()));
			toll.setOffPeakTrips(calcOffPeakHours(zcf.getSR167(), carFactor, toll.isUsed()));
		}
	}
	
	/**
	 * Calculates the peak hours
	 */
	private static int calcPeakHours(int zipcodeFactor, float carFactor, int driveAlone, int carpool, int numPassengers, boolean included) {
		int rate = (int)(carFactor * PEAK_USAGE);
		if(included) {
			rate = rate + (driveAlone * WEEKS_IN_YEAR + (carpool * WEEKS_IN_YEAR)/numPassengers) -  zipcodeFactor * (int)(carFactor * PEAK_USAGE); 
		}
		return rate;
	}
	
	/**
	 * Calculates the off peak hours
	 */
	private static int calcOffPeakHours(int zipcodeFactor, float carFactor, boolean included) {
		if(!included) return 0;
		return zipcodeFactor * (int)(carFactor * OFF_PEAK_USAGE); 
	}
	
	/**
	 * Creates a report from the provided UserTaxInfoDTO and funding suite
	 * 
	 * @param	user	The UserTaxInfoDTO with all the info in it
	 * @param	fundingSuiteID	The funding suite 
	 */
	public UserTaxInfoDTO calcCostReport(UserTaxInfoDTO user, Long fundingSuiteId) throws Exception {

		//Save the new info to the commute object
		
		//Go through the funding suite and calculate the users costs
		
		//Go through the tolls and calculate the costs
		
System.out.println("MATT: FundingSuiteID = " + fundingSuiteId);
		//TODO fill out the report here
		Set<String> headers = new HashSet<String>();
		headers.add("Sales tax increates with vehicle");
		headers.add("your weight in drams");
		
		Set<String> data1 = new HashSet<String>();
		data1.add("200%");
		data1.add("3435");
		
		Set<String> data2 = new HashSet<String>();
		data2.add("100%" + fundingSuiteId);
		data2.add("332435");
				
		PersonalFundingCostAlternative p1 = new PersonalFundingCostAlternative();
		p1.setData(data1);
		
		PersonalFundingCostAlternative p2 = new PersonalFundingCostAlternative();
		p2.setData(data2);
		
		Set<PersonalFundingCostAlternative> alts = new HashSet<PersonalFundingCostAlternative>();
		alts.add(p1);
		alts.add(p2);
		
		Set<PersonalFundingCost> costs = new HashSet<PersonalFundingCost>();
		PersonalFundingCost c1 = new PersonalFundingCost();
		c1.setHeaders(headers);
		c1.setAlternatives(alts);

		costs.add(c1);		
		user.setCosts(costs);

				
		return user;
	}
	
	/**
	 * Returns the User asked for
	 * 
	 * @param	userId	The ID of the user desired
	 */
	public UserTaxInfoDTO getUserTaxInfoDTO(Long userId) throws Exception {
		UserTaxInfoDTO utax = new UserTaxInfoDTO();
		utax.loadWithUserInfo(this.fundingDAO.getUserById(userId));
		return utax;
	}
		
	/**
	 * Updates the users information.
	 * 
	 * NOTE: This only updates information related to the FundingCalculator game
	 * 
	 * @param	user	The user to update
	 * @return	The saved user class
	 */
	public User updateUserTaxInfo(UserTaxInfoDTO user) throws Exception {
		
		//Load the original user
		User tempUser = this.fundingDAO.getUserById(user.getUserId());
		
		user.loadUserWithData(tempUser);
		
		//Save it
		this.fundingDAO.save(tempUser);
		return tempUser;
	}

	/**
	 * Adds a vehicle to the user
	 * 
	 * @param	userId	The userID
	 * @param	mpg	Miles per gallon
	 * @param	value	Value of the vehicle
	 * @param	mpy	Miles per year
	 * @throws Exception 
	 */
	public UserTaxInfoDTO addVehicle(Long userId, Float mpg, Float value, Float mpy) throws Exception {
		User user = this.fundingDAO.getUserById(userId);

		Vehicle v = new Vehicle();
		v.setApproxValue(value);
		v.setMilesPerGallon(mpg);
		v.setMilesPerYear(mpy);
		
		user.getVehicles().add(v);
		this.fundingDAO.save(user);
		this.fundingDAO.save(v);
		
		return this.getUserTaxInfoDTO(userId);
	}

	/**
	 * Updates the vehicle
	 * 
	 * @param	vehicleId	The ID of the vehicle
	 * @param	mpg	Miles per gallon
	 * @param	value	Value of the vehicle
	 * @param	mpy	Miles per year
	 * @throws Exception 
	 */
	public void updateVehicle(Long vehicleId, Float mpg, Float value, Float mpy) throws Exception {
		
		Vehicle v = this.fundingDAO.getVehicle(vehicleId);
		v.setApproxValue(value);
		v.setMilesPerGallon(mpg);
		v.setMilesPerYear(mpy);
		this.fundingDAO.save(v);
	}
	
	/**
	 * Removes the vehicle
	 * 
	 * @param	userId
	 * @param	vehicleId
	 */
	public UserTaxInfoDTO deleteVehicle(Long userId, Long vehicleId) throws Exception {
		User user = this.fundingDAO.getUserById(userId);
		
		Iterator<Vehicle> i = user.getVehicles().iterator();
		Vehicle tempV;
		while(i.hasNext()) {
			tempV = i.next();
			if(tempV.getId().equals(vehicleId)) {
				user.getVehicles().remove(tempV);
				this.fundingDAO.delete(tempV);
				this.fundingDAO.save(user);
				break;
			}
		}
		
		return this.getUserTaxInfoDTO(userId);
	}
	
    /**
     * Relate the given FundingAlternative object to FundingSuite object
     */
    public void relateFundingAlt(Long suiteId, Long altId) throws Exception {
    	FundingSourceSuite suite = fundingDAO.getFundingSuite(suiteId);
    	    	
    	//Check in the suite to see if if there is a Funding the alternative is already related
    	if(!suite.containsAlts(altId)) {
    		
        	//If not then, load the alternative
        	FundingSourceAlternative alternative = fundingDAO.getFundingSourceAlternative(altId);
    		
        	//Relate it back to the Alt Ref 
        	FundingSourceAltRef altRef = new FundingSourceAltRef();
        	altRef.setAlternative(alternative);
        	fundingDAO.save(altRef);
    		
           	//Pull the funding ID from the alternative
        	FundingSource funding = alternative.getSource();
        	
        	//Get the funding reference
        	FundingSourceRef fundingReference = suite.getFundingSourceReference(funding);
        	
        	//If the reference doesn't exist then create it and add the funding
        	if(fundingReference == null) {
        		fundingReference = new FundingSourceRef();
        		fundingReference.setSuite(suite);
        		fundingReference.setSource(funding);
        		
            	//Save the funding reference
            	fundingDAO.save(fundingReference);
            	
            	//Add it to the suite
            	suite.getReferences().add(fundingReference);
            	
            	//Save the suite (thus connecting the suite and funding ref together
            	fundingDAO.save(suite);       		
        	}
        	
        	//Now put the altRef into the funding ref
        	fundingReference.getAltRefs().add(altRef);
        	
        	//Save the funding reference
        	fundingDAO.save(fundingReference);
        	    		
    	}    	
    }//relateFundingAlt()


    /**
     * Derelates the given FundingSourceAlternative object to FundingSourceSuite object
     * 
     * @param	suiteId	The id of the suite to remove the reference from
     * @param	altId	The alternative ID that tells of the funding alternative to remove
     */
    public void derelateFundingAlt(Long suiteId, Long altId) throws Exception {
    	//Get a reference to the suite
    	FundingSourceSuite suite = fundingDAO.getFundingSuite(suiteId);
    	
    	if(suite == null) throw new UnknownFundingSuite("Unknown FundingSource Suite [" + suiteId +"]");
    	    	
    	FundingSourceAlternative fundingAlt = fundingDAO.getFundingSourceAlternative(altId);

    	//Get the funding reference that has this alternative reference in it
    	FundingSourceRef fundingRef = suite.getFundingSourceReference(fundingAlt);    	
    	FundingSourceAltRef altRef = fundingRef.getFundingSourceAltRef(fundingAlt);
    	    	
    	if(fundingRef != null) {
    		//Remove the reference to the alt ref
    		fundingRef.removeAltRef(altRef);
    		
        	//Delete the funding alterative reference provided
    		fundingDAO.delete(altRef);
        	
        	//If that was the last alternative in that funding reference then delete the funding reference
    		if(fundingRef.getNumAltRefs() <= 0) {
    			fundingDAO.delete(fundingRef);
    		} else {
    			fundingDAO.save(fundingRef);
    		}
    	}    	
    }//derelateFundingAlt()
    

    /*
     * ------------------------------------------------------------------------
     */
    
    
    public FundingSourceAlternative getFundingSourceAltById(Long id) throws Exception {
        return fundingDAO.getFundingSourceAltById(id);
    }//getFundingSourceAltById()


    public FundingSource getFundingSourceById(Long id) throws Exception {
        return fundingDAO.getFundingSourceById(id);
    }//getFundingSourceById()
    
    
    public Collection getFundingSources() throws Exception {
        return fundingDAO.getFundingSources();
    }//getFundingSources()


    public FundingSource createFundingSource(String name, int type) throws Exception {
        /*
         * Check if the same name exists.
         */
        FundingSource funding = fundingDAO.getFundingSourceByName(name);
        if (funding!=null) throw new Exception("another funding source with the same name already exists");
        
        /*
         * Name available, create the funding source
         */
        
        funding = new FundingSource();
        funding.setName(name);
        funding.setType(type);
        
        fundingDAO.save(funding);
        
        return funding;
    }//createFundingSource()


    public void editFundingSource(Long id, String name, int type) throws Exception {
        /*
         * Retrieve the funding source
         */
        FundingSource funding = fundingDAO.getFundingSourceById(id);
        if (funding==null) throw new Exception("can't find this funding source");
        
        funding.setName(name);
        funding.setType(type);
        
        fundingDAO.save(funding);
    }//editFundingSource()


    public void deleteFundingSource(Long id) throws Exception {
    	FundingSource source = fundingDAO.getFundingSourceById(id);
    	fundingDAO.delete(source);
    }//deleteFundingSource()


    public FundingSourceAlternative createFundingSourceAlt(Long id, String name, float revenue, float taxRate, String source, float avgCost, boolean toll, float peakHourTrips, float offPeakTrips) throws Exception {
    	FundingSource funSource = fundingDAO.getFundingSourceById(id);
    	
    	FundingSourceAlternative alternative = new FundingSourceAlternative();
    	alternative.setName(name);
    	alternative.setRevenue(revenue);
    	alternative.setTaxRate(taxRate);
    	alternative.setSourceURL(source);
    	alternative.setAvgCost(avgCost);
    	alternative.setToll(toll);
    	alternative.setPeakHourTripsRate(peakHourTrips);
    	alternative.setOffPeakTripsRate(offPeakTrips);
    	
    	fundingDAO.save(alternative);
    	
    	funSource.getAlternatives().add(alternative);
    	
    	fundingDAO.save(funSource);
    	
        return alternative;
    }//createFundingSourceAlt()


    public void editFundingSourceAlt(Long id, String name, float revenue, float taxRate, String source, float avgCost, boolean toll, float peakHourTrips, float offPeakTrips) throws Exception {
   	
    	FundingSourceAlternative alternative = fundingDAO.getFundingSourceAltById(id);
    	alternative.setName(name);

    	alternative.setRevenue(revenue);
    	alternative.setTaxRate(taxRate);
    	alternative.setSourceURL(source);
    	alternative.setAvgCost(avgCost);
    	alternative.setToll(toll);
    	alternative.setPeakHourTripsRate(peakHourTrips);
    	alternative.setOffPeakTripsRate(offPeakTrips);
    	
    	fundingDAO.save(alternative);
    }//editFundingSourceAlt()


    public void deleteFundingSourceAlt(Long id) throws Exception {
    	
    	FundingSourceAlternative alternative = fundingDAO.getFundingSourceAltById(id);
    	fundingDAO.delete(alternative);

    	
    	
    }//deleteFundingSourceAlt()


    /**
     * Setup the association between funding sources and CCT.
     * 
     * @param cctId id of the CCT object to be associated
     * @param ids ids of FundingSource objects to be assosicated
     * @throws Exception
     */
    public void setupFundingSourcesForCCT(Long cctId, String[] ids) throws Exception {
        /*
         * TODO:
         *   Load CCT object by cctId, throw exception if failed
         *   Load each ProjectAlternative object by id, throw exception if any failed
         *   put each ProjectAlternative object to CCT.projects
         *   persist objects
         */
    }//setupFundingSourcesForCCT()


	public FundingSourceSuite getFundingSuite(Long suiteId) throws Exception {
		return fundingDAO.getFundingSuite(suiteId);
	}
	
    
    public FundingSourceSuite createFundingSourceSuite() throws Exception {
        FundingSourceSuite suite = new FundingSourceSuite();
        
        fundingDAO.save(suite);
        
        return suite;
    }//createFundingSourceSuite()

    

}//class FundingServiceImpl
