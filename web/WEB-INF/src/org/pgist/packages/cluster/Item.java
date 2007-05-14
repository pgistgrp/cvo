/**
 * Copyright 2003 by Markus Maier, mkm@gmx.de
 * 
 * Released under the GNU General Public License,
 * see http://www.gnu.org/licenses/gpl.html
 *
 * $Id$
 * $Log$
 * Revision 1.3  2003/10/16 14:31:29  mkmaier
 * IMP: minor beautifying
 *
 * Revision 1.2  2003/10/02 15:14:05  mkmaier
 * Extensive refactoring to clean up dependencies and code duplications. The design should now be much, much cleaner. First compile error free version, does not work, though.
 *
 * Revision 1.1  2003/10/01 12:01:39  mkmaier
 * IMP: moved to ..data
 * IMP: Element cleaned up and renamed to Item
 *
 */
package org.pgist.packages.cluster;

/**
 * Class representing an item of data.
 * 
 * @author Markus Maier
 * @version 0.1
 */
public interface Item extends Clusterable {
	/**
	 * Returns the user object for this Item.
	 * 
	 * @return The user object for this Item.
	 */
	//	Object getUserObject();

	/**
	 * Sets the user object for this Item.
	 * 
	 * @param userObject
	 *            The new user object.
	 */
	//	void setUserObject(Object userObject);
}