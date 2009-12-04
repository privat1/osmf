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
	
	import org.osmf.events.FacetValueChangeEvent;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.metadata.NullFacetSynthesizer;
	import org.osmf.metadata.StringIdentifier;

	public class TestAbsoluteLayoutFacet extends TestCase
	{
		public function testAbsoluteLayoutFacet():void
		{
			var lastEvent:FacetValueChangeEvent;
			var eventCounter:int = 0;

			function onFacetChange(event:FacetValueChangeEvent):void
			{
				lastEvent = event;
				eventCounter++;
			}
			
			var facet:AbsoluteLayoutFacet = new AbsoluteLayoutFacet();
			facet.addEventListener(FacetValueChangeEvent.VALUE_CHANGE, onFacetChange);
						
			assertEquals(facet.namespaceURL, MetadataNamespaces.ABSOLUTE_LAYOUT_PARAMETERS);
			
			facet.x = 1;
			
			assertEquals(1, eventCounter);
			assertEquals(AbsoluteLayoutFacet.X, lastEvent.identifier);
			assertEquals(NaN, lastEvent.oldValue);
			assertEquals(1, lastEvent.value);
			assertEquals(facet.x, facet.getValue(AbsoluteLayoutFacet.X), 1);
			
			facet.y = 2;
			
			assertEquals(2, eventCounter);
			assertEquals(AbsoluteLayoutFacet.Y, lastEvent.identifier);
			assertEquals(NaN, lastEvent.oldValue);
			assertEquals(2, lastEvent.value);
			assertEquals(facet.y, facet.getValue(AbsoluteLayoutFacet.Y), 2);
			
			facet.width = 3;
			
			assertEquals(3, eventCounter);
			assertEquals(AbsoluteLayoutFacet.WIDTH, lastEvent.identifier);
			assertEquals(NaN, lastEvent.oldValue);
			assertEquals(3, lastEvent.value);
			assertEquals(facet.width, facet.getValue(AbsoluteLayoutFacet.WIDTH), 3);
			
			facet.height = 4;
			
			assertEquals(4, eventCounter);
			assertEquals(AbsoluteLayoutFacet.HEIGHT, lastEvent.identifier);
			assertEquals(NaN, lastEvent.oldValue);
			assertEquals(4, lastEvent.value);
			assertEquals(facet.height, facet.getValue(AbsoluteLayoutFacet.HEIGHT), 4);
			
			assertEquals(undefined, facet.getValue(null));
			assertEquals(undefined, facet.getValue(new StringIdentifier("@*#$^98367423874")));
			
			assertTrue(facet.synthesizer is NullFacetSynthesizer);
		}
		
	}
}