package org.pgist.packages.knapsack;

import org.jgap.IChromosome;


/**
 * 
 * @author kenny
 *
 */
interface GAKnapsackFitnessProxy {
    
    
    void setCalculator(GAKnapsackCalculator calculator);
     
    double evaluate(IChromosome chromosome);
    
    
}//class GAKnapsackFitnessProxy
