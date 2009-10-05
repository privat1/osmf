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
package org.openvideoplayer.traits
{
	import org.openvideoplayer.events.DurationChangeEvent;
	import org.openvideoplayer.events.TraitEvent;
	
	public class TestTemporalTrait extends TestITemporal
	{
		override protected function createInterfaceObject(... args):Object
		{
			return new TemporalTrait();
		}
		
		public function testDuration():void
		{
			temporal.addEventListener(DurationChangeEvent.DURATION_CHANGE,eventCatcher);
			
			assertTrue(isNaN(temporal.duration));
			
			temporalTraitBase.duration = 10;
			assertTrue(temporal.duration == 10);
			
			temporalTraitBase.duration = 20;
			assertTrue(temporal.duration == 20);
			
			assertTrue(events.length == 2);
			
			var dce:DurationChangeEvent;
			
			dce = events[0] as DurationChangeEvent;
			assertNotNull(dce);
			assertTrue(isNaN(dce.oldDuration));
			assertTrue(dce.newDuration == 10);
			
			dce = events[1] as DurationChangeEvent;
			assertNotNull(dce);
			assertTrue(dce.oldDuration == 10);
			assertTrue(dce.newDuration == 20); 
		}
		
		public function testPosition():void 
		{
			assertTrue(isNaN(temporal.position));
			
			if (canChangePosition)
			{
				// Position must never exceed duration.
				temporalTraitBase.position = 10;
				assertTrue(temporal.position == 0);
	
				temporalTraitBase.duration = 25;
				temporalTraitBase.position = 10;
				assertTrue(temporal.position == 10);
				temporalTraitBase.position = 50;
				assertTrue(temporal.position == 25);
				temporalTraitBase.duration = 5;
				assertTrue(temporal.position == 5);
				
				// Setting the position to the duration should cause the
				// durationReached event to fire.
				
				temporal.addEventListener(TraitEvent.DURATION_REACHED,eventCatcher);
				
				temporalTraitBase.duration = 20;
				temporalTraitBase.position = 20;
				
				var dre:TraitEvent;
				dre = events[0] as TraitEvent;
				assertNotNull(dre && dre.type == TraitEvent.DURATION_REACHED);
			}
		}
		
		// Utils
		//
		
		protected function get temporalTraitBase():TemporalTrait
		{
			return temporal as TemporalTrait;
		}
		
		protected function get canChangePosition():Boolean
		{
			// Subclasses can override if explicit position changes are
			// disallowed.
			return true;
		}
	}
}