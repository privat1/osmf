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
package org.osmf.external
{
	import org.osmf.traits.AudioTrait;

	/**
	 * @private
	 */
	internal class HTMLAudioTrait extends AudioTrait
	{
		public function HTMLAudioTrait(owner:HTMLElement)
		{
			this.owner = owner;
			
			super();
		}
		
		public function setVolume(value:Number):void
		{
			internalMutation++;
			
			setVolume(value);
			
			internalMutation--;	
		}
		
		public function setMuted(value:Boolean):void
		{
			internalMutation++;
			
			setMuted(value);
			
			internalMutation--;
		}
		
		public function setPan(value:Number):void
		{
			internalMutation++;
			
			setPan(value);
			
			internalMutation--;
		}
		
		// Overrides
		//
		
		override protected function processVolumeChange(newVolume:Number):void
		{
			super.processVolumeChange(newVolume);
			
			if (internalMutation == 0)
			{
				owner.invokeJavaScriptMethod("onVolumeChange", newVolume);
			}
		} 
		
		override protected function processMutedChange(newMuted:Boolean):void
		{
			super.processMutedChange(newMuted);
			
			if (internalMutation == 0)
			{
				owner.invokeJavaScriptMethod("onMutedChange", newMuted);
			}
		}
		
		override protected function processPanChange(newPan:Number):void
		{
			super.processPanChange(newPan);
			
			if (internalMutation == 0)
			{
				owner.invokeJavaScriptMethod("onPanChange", newPan);
			}
		}
		
		// Internals
		//
		
		private var owner:HTMLElement;
		private var internalMutation:int;	
	}
}