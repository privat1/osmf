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
package com.adobe.strobe.players
{
	import flash.events.Event;
	
	import mx.core.UIComponent;
	
	import org.osmf.display.MediaPlayerSprite;
	import org.osmf.events.DisplayObjectEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaPlayer;
	
	/**
	 * Defines a Flex wrapper class for the MediaPlayerSprite class.
	 */	
	public class MediaPlayerWrapper extends UIComponent
	{		
		// Public API
		//
		
		public function set element(value:MediaElement):void
		{
			mediaPlayer.element = value;
		}
		
		public function get element():MediaElement
		{
			return mediaPlayer.element;
		}	
		
		[ChangeEvent('mediaPlayerChange')]
		public function get mediaPlayer():MediaPlayer
		{
			return _playerSprite.mediaPlayer;
		}
		
		public function set scaleMode(value:String):void
		{
			_playerSprite.scaleMode = value;
		}
		
		public function get scaleMode():String
		{
			return _playerSprite.scaleMode;
		}
		
		
		
		// Overrides
		//
		
		override protected function measure():void
		{
			measuredWidth = 640;
			measuredHeight = 480;
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			_playerSprite = new MediaPlayerSprite();				
			addChild(_playerSprite);
			
			dispatchEvent(new Event("mediaPlayerChange"));
		}
			
		override protected function updateDisplayList(w:Number, h:Number):void
		{	
			super.updateDisplayList(w,h);
			
			_playerSprite.setAvailableSize(w,h);
		}
				
		// Internals
		//
													
		protected function onView(event:DisplayObjectEvent):void
		{
			if (event.oldDisplayObject)
			{
				removeChild(event.oldDisplayObject);
			}
			
			if (event.newDisplayObject)
			{				
				addChild(mediaPlayer.view);
			}
			
			invalidateDisplayList();			
		}
				
		private function redispatch(event:Event):void
		{
			dispatchEvent(event.clone());
		}
					
		protected var _playerSprite:MediaPlayerSprite;
	}
}
