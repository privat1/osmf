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
package org.openvideoplayer.vast.media
{
	import __AS3__.vec.Vector;
	
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.proxies.ListenerProxyElement;
	import org.openvideoplayer.tracking.Beacon;
	import org.openvideoplayer.traits.IBufferable;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.utils.HTTPLoader;
	import org.openvideoplayer.utils.MediaFrameworkStrings;
	import org.openvideoplayer.utils.URL;
	import org.openvideoplayer.vast.model.VASTUrl;
	
	/**
	 * A VASTImpressionProxyElement is a ProxyElement that wraps up another
	 * MediaElement, and which records one or more impressions according to the
	 * IAB's guidelines for impression tracking.
	 * 
	 * According to the IAB, an impression should only be recorded after
	 * the media has initially exited the buffering state.
	 **/
	public class VASTImpressionProxyElement extends ListenerProxyElement
	{
		/**
		 * Constructor.
		 * 
		 * @param urls The VASTUrls to request in order to record the impressions.
		 * @param httpLoader The HTTPLoader to use to ping the beacon.  If null,
		 * then a default HTTPLoader will be used.
		 * @param wrappedElement The MediaElement to wrap.
		 **/
		public function VASTImpressionProxyElement(urls:Vector.<VASTUrl>=null, httpLoader:HTTPLoader=null, wrappedElement:MediaElement=null)
		{
			this.urls = urls;
			this.httpLoader = httpLoader;
			
			impressionsRecorded = false;
			waitForBufferingExit = false;
			
			super(wrappedElement);
		}
		
		/**
         * @private
		 **/
		override public function initialize(value:Array):void
		{
			if (value && value.length == 2)
			{
				this.urls = value[0] as Vector.<VASTUrl>;
				this.httpLoader = value[1] as HTTPLoader;
			}
			else
			{
				throw new ArgumentError(MediaFrameworkStrings.INVALID_INITIALIZATION_ARGS);
			}
		}
		
		// Overrides
		//
		
		/**
		 * @private
		 **/
		override protected function processLoadableStateChange(oldState:LoadState, newState:LoadState):void
		{
			if (newState == LoadState.LOADED)
			{
				// Reset our internal flags so that we can record a new
				// impression.
				impressionsRecorded = false;
				waitForBufferingExit = false;
			}
		}
		
		/**
		 * @private
		 **/
		override protected function processPlayingChange(playing:Boolean):void
		{
			if (playing && !impressionsRecorded)
			{
				// Only record the impressions if we're not buffering.
				var bufferable:IBufferable = getTrait(MediaTraitType.BUFFERABLE) as IBufferable;
				if (	bufferable == null
					||  ( 	bufferable.buffering == false 
						&& 	bufferable.bufferLength >= bufferable.bufferTime
						)
				   )
				{
					recordImpressions();
				}
				else
				{
					// Wait until we exit the buffering state.
					waitForBufferingExit = true;
				}
			}
		}
		
		/**
		 * @private
		 **/
		override protected function processBufferingChange(buffering:Boolean):void
		{
			if (	buffering == false
				&&  impressionsRecorded == false
				&&  waitForBufferingExit
				)
			{
				recordImpressions();
			}
		}

		// Internals
		//
		
		private function recordImpressions():void
		{
			impressionsRecorded = true;
			
			for each (var vastUrl:VASTUrl in urls)
			{
				var beacon:Beacon = new Beacon(new URL(vastUrl.url), httpLoader);
				beacon.ping();
			}
		}

		private var urls:Vector.<VASTUrl>;
		private var httpLoader:HTTPLoader;
		private var impressionsRecorded:Boolean;
		private var waitForBufferingExit:Boolean;
	}
}