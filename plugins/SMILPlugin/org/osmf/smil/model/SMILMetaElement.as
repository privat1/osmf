/*****************************************************
*  
*  Copyright 2009 Akamai Technologies, Inc.  All Rights Reserved.
*  
*****************************************************
*  The contents of this file are subject to the Mozilla Public License
*  Version 1.1 (the "License"); you may not use this file except in
*  compliance with the License. You may obtain a copy of the License at
*  http://www.mozilla.org/MPL/
*   
*  Software distributed under the License is distributed on an "AS IS"
*  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
*  License for the specific language governing rights and limitations
*  under the License.
*   
*  
*  The Initial Developer of the Original Code is Akamai Technologies, Inc.
*  Portions created by Akamai Technologies, Inc. are Copyright (C) 2009 Akamai 
*  Technologies, Inc. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.smil.model
{
	import org.osmf.utils.URL;
	
	/**
	 * Represents a meta tag in a SMIL document.
	 */
	public class SMILMetaElement extends SMILElement
	{
		/**
		 * Constructor.
		 */
		public function SMILMetaElement()
		{
			super(SMILElementType.META);
		}
		
		/**
		 * The <code>base</code> attribute value if 
		 * found with the tag in the SMIL file.
		 */
		public function get base():URL
		{
			return _base;
		}
		
		public function set base(value:URL):void
		{
			_base = value;
		}
		
		private var _base:URL;
	}
}