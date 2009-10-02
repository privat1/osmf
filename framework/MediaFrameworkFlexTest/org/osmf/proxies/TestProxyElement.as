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
package org.osmf.proxies
{
	import flash.errors.IllegalOperationError;
	
	import org.osmf.media.IMediaResource;
	import org.osmf.media.MediaElement;
	import org.osmf.media.TestMediaElement;
	import org.osmf.media.URLResource;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.DynamicMediaElement;
	import org.osmf.utils.SimpleLoader;
	import org.osmf.utils.URL;

	public class TestProxyElement extends TestMediaElement
	{
		public function testConstructor():void
		{
			// No exception here.
			new ProxyElement(new MediaElement());
			
			// No exception here (though the wrappedElement must be set later).
			new ProxyElement(null);
		}
		
		public function testSetWrappedElement():void
		{
			var proxyElement:ProxyElement = createProxyElement();
			
			// Most operations will fail until the wrappedElement is set.
			try
			{
				proxyElement.resource = new URLResource(null);
				
				fail();
			}
			catch (error:IllegalOperationError)
			{
			}
			
			try
			{
				proxyElement.hasTrait(MediaTraitType.TEMPORAL);

				fail();
			}
			catch (error:IllegalOperationError)
			{
			}
			
			var wrappedElement:DynamicMediaElement
				= new DynamicMediaElement( [MediaTraitType.TEMPORAL, MediaTraitType.LOADABLE]
										 , new SimpleLoader()
										 );

			proxyElement.wrappedElement = wrappedElement;
			
			assertTrue(proxyElement.hasTrait(MediaTraitType.TEMPORAL));
			assertTrue(proxyElement.hasTrait(MediaTraitType.PLAYABLE) == false);
			
			// Setting a new wrapped element is possible.  Doing so should
			// cause the proxy's traits to change.
			//
			
			var wrappedElement2:DynamicMediaElement
				= new DynamicMediaElement( [MediaTraitType.PLAYABLE, MediaTraitType.LOADABLE]
										 , new SimpleLoader()
										 );
			
			proxyElement.wrappedElement = wrappedElement2;
			
			assertTrue(proxyElement.hasTrait(MediaTraitType.TEMPORAL) == false);
			assertTrue(proxyElement.hasTrait(MediaTraitType.PLAYABLE));
			
			// Clearing the wrapped element is also possible.  This should
			// clear out the traits, and make many operations invalid.
			//
			
			proxyElement.wrappedElement = null;
			
			assertTrue(proxyElement.wrappedElement == null);

			try
			{
				proxyElement.hasTrait(MediaTraitType.TEMPORAL);

				fail();
			}
			catch (error:IllegalOperationError)
			{
			}
		}
		
		// Protected
		//
		
		protected function createProxyElement():ProxyElement
		{
			return new ProxyElement();
		}
		
		// Overrides
		//
		
		override protected function createMediaElement():MediaElement
		{
			return new ProxyElement(new MediaElement());
		}
		
		override protected function get loadable():Boolean
		{
			return false;
		}
		
		override protected function get resourceForMediaElement():IMediaResource
		{
			return new URLResource(new URL("http://example.com"));
		}
		
		override protected function get existentTraitTypesOnInitialization():Array
		{
			return [];
		}

		override protected function get existentTraitTypesAfterLoad():Array
		{
			return [];
		}
	}
}