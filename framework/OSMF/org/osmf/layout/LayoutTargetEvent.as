/*****************************************************
*  
*  Copyright 2010 Adobe Systems Incorporated.  All Rights Reserved.
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
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2010 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/

package org.osmf.layout
{
	import flash.events.Event;

	internal class LayoutTargetEvent extends Event
	{
		/**
		 * Constant that defines the value of the type property of the event object for
		 * a setAsLayoutRendererContainer event.
		 * 
		 * @eventType SET_AS_LAYOUT_RENDERER_CONTAINER 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public static const SET_AS_LAYOUT_RENDERER_CONTAINER:String = "setAsLayoutRendererContainer";
		
		/**
		 * Constant that defines the value of the type property of the event object for
		 * a unsetAsLayoutRendererContainer event.
		 * 
		 * @eventType UNSET_AS_LAYOUT_RENDERER_CONTAINER 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public static const UNSET_AS_LAYOUT_RENDERER_CONTAINER:String = "unsetAsLayoutRendererContainer";
		
		/**
		 * Constant that defines the value of the type property of the event object for
		 * a addToLayoutRenderer event.
		 * 
		 * @eventType ADD_TO_LAYOUT_RENDERER 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public static const ADD_TO_LAYOUT_RENDERER:String = "addToLayoutRenderer";
		
		/**
		 * Constant that defines the value of the type property of the event object for
		 * a removeFromLayoutRenderer event.
		 * 
		 * @eventType REMOVE_FROM_LAYOUT_RENDERER 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
		public static const REMOVE_FROM_LAYOUT_RENDERER:String = "removeFromLayoutRenderer";
		
		/**
		 * Constructor
		 *  
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 * @param layoutRenderer
		 * 
		 */		
		public function LayoutTargetEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, layoutRenderer:LayoutRendererBase = null)
		{
			_layoutRenderer = layoutRenderer;
			super(type, bubbles, cancelable);
		}
		
		/**
		 * Defines the layout renderer associated with the event.
		 */		
		public function get layoutRenderer():LayoutRendererBase
		{
			return _layoutRenderer;
		}
		
		// Overrides
		//
		
		/**
		 * @inheritDoc
		 */		
		override public function clone():Event
		{
			return new LayoutTargetEvent(type, bubbles, cancelable, _layoutRenderer);
		}
		
		// Internals
		//
		
		private var _layoutRenderer:LayoutRendererBase;
	}
}