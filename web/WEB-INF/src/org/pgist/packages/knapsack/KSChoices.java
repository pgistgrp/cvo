package org.pgist.packages.knapsack;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

import org.pgist.tests.packages.knapsack.CostComparator;

/**
 * Used to hold multiple mutually exclusive choices of KSItems
 * 
 * @author Matt Paulin
 */
public class KSChoices {
	
	private static final CostComparator WEIGHT_SORTER = new CostComparator(); 	
	
	private List<KSItem> choices = new ArrayList<KSItem>();

	/**
	 * @return the choices
	 */
	public List<KSItem> getChoices() {
		return choices;
	}

	/**
	 * @param choices the choices to set
	 */
	public void setChoices(List<KSItem> choices) {
		this.choices = choices;
	}	
	
	/**
	 * Remove dominated items
	 */
	public void removeDominatedItems() {
		//Sort everything in class by increasing cost
//		Collections.sort(choices, WEIGHT_SORTER);
		
		List<KSItem> undominated = new ArrayList<KSItem>();
		KSItem checkItem;
		KSItem otherItem;
		boolean dominated = false;
		for(int i = 0; i < choices.size(); i++) {
			dominated = false;
			checkItem = choices.get(i);
			for(int j = 0; j < choices.size(); j++) {
				if(i != j) {
					otherItem = choices.get(j);
					if(otherItem.dominates(checkItem)) {
						dominated = true;
						break;
					}					
				}
			}
			if(!dominated) {
				undominated.add(checkItem);
			}
		}
		choices = undominated;
	}
	
}