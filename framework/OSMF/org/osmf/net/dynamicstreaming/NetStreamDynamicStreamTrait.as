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
*  Contributor(s): Adobe Systems Incorporated.
* 
*****************************************************/
package org.osmf.net.dynamicstreaming
{
	import flash.events.NetStatusEvent;
	
	import org.osmf.events.DynamicStreamEvent;
	import org.osmf.net.NetStreamCodes;
	import org.osmf.traits.DynamicStreamTrait;
	import org.osmf.utils.OSMFStrings;

	[ExcludeClass]
	
	/**
	 * @private
	 * 
	 * The NetStreamDynamicStreamTrait class extends DynamicStreamTrait for NetStream-based
	 * dynamic streaming.
	 */   
	public class NetStreamDynamicStreamTrait extends DynamicStreamTrait
	{
		/**
		 * Constructor.
		 * 
		 * @param netStream The DynamicNetStream object the class will work with.
		 * @param dsResource The DynamicStreamingResource the class will use.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function NetStreamDynamicStreamTrait(netStream:DynamicNetStream, dsResource:DynamicStreamingResource)
		{
			super(netStream.autoSwitch, netStream.renderingIndex, dsResource.streamItems.length);	
			
			this.netStream = netStream;
			this.dsResource = dsResource;
									
			netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			netStream.addEventListener(DynamicStreamEvent.SWITCHING_CHANGE, onNetStreamSwitchingChange);
		}
		
		/**
		 * @private
		 */
		override public function getBitrateForIndex(index:int):Number
		{
			if (index > numDynamicStreams - 1 || index < 0)
			{
				throw new RangeError(OSMFStrings.getString(OSMFStrings.STREAMSWITCH_INVALID_INDEX));
			}

			return dsResource.streamItems[index].bitrate;
		}	
				
		/**
		 * @private
		 */
		override protected function switchingChangeStart(newSwitching:Boolean, index:int, detail:SwitchingDetail=null):void
		{
			if (newSwitching && !netStreamIsSwitching)
			{
				// Keep track of the target index, we don't want to begin
				// the switch now since our switching state won't be
				// updated until the switchingChangeEnd method is called.
				indexToSwitchTo = index;
			}
		}
		
		/**
		 * @private
		 */
		override protected function switchingChangeEnd(index:int, detail:SwitchingDetail=null):void
		{
			super.switchingChangeEnd(index, detail);
			
			if (switching && !netStreamIsSwitching)
			{
				netStream.switchTo(indexToSwitchTo);
			}
		}
			
		/**
		 * @private
		 */
		override protected function autoSwitchChangeStart(value:Boolean):void
		{
			netStream.autoSwitch = value;
		}
		
		/**
		 * @private
		 */ 
		override protected function maxAllowedIndexChangeStart(value:int):void
		{
			netStream.maxAllowedIndex = value;
		}
						
		private function onNetStatus(event:NetStatusEvent):void
		{			
			if (switching)
			{
				switch (event.info.code) 
				{
					case NetStreamCodes.NETSTREAM_PLAY_FAILED:					
						setSwitching(false, currentIndex);					
						break;
				}
			}			
		}
		
		private function onNetStreamSwitchingChange(event:DynamicStreamEvent):void
		{
			if (event.type == DynamicStreamEvent.SWITCHING_CHANGE)
			{
				// When a switch finishes, make sure our current index and switching
				// state reflect the changes to the NetStream.
				if (event.switching == false)
				{
					setCurrentIndex(netStream.renderingIndex);
					setSwitching(false, netStream.renderingIndex);
				}
				else
				{
					// This switch is driven by the NetStream, we set a member
					// variable so that we don't assume it's being requested by
					// the client (and thus trigger a second switch).
					netStreamIsSwitching = true;
					
					// TODO: Fix the index, this is the wrong value.
					setSwitching(true, netStream.renderingIndex);
					
					netStreamIsSwitching = false;
				}
			}
		}				
		
		private var netStream:DynamicNetStream;
		private var netStreamIsSwitching:Boolean;
		private var dsResource:DynamicStreamingResource;
		private var indexToSwitchTo:int;	
	}
}