/*****************************************************
*  
*  Copyright 2009 Adobe Systems Incorporated.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is Adobe Systems Incorporated.
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2009 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.layout
{
	import flexunit.framework.TestCase;

	public class TestLayoutContextSprite extends TestCase
	{
		public function testLayoutContextSprite():void
		{
			var lcs:LayoutContextSprite = new LayoutContextSprite();
			var renderer:LayoutRenderer = new DefaultLayoutRenderer();
			renderer.context = lcs;
			
			var child1:TesterLayoutTargetSprite = new TesterLayoutTargetSprite();
			var child2:TesterLayoutTargetSprite = new TesterLayoutTargetSprite();
			
			renderer.addTarget(child1);
			renderer.addTarget(child2);
			
			assertEquals(0, lcs.intrinsicWidth);
			assertEquals(0, lcs.intrinsicHeight);
			
		}
		
	}
}