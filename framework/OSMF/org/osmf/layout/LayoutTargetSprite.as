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
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import org.osmf.events.DisplayObjectEvent;
	import org.osmf.logging.ILogger;
	import org.osmf.metadata.Metadata;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.utils.ExternalProperty;

	/**
	 * Dispatched when a layout element's media width and height changed.
	 * 
	 * @eventType org.osmf.events.DisplayObjectEvent.MEDIA_SIZE_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	
	[Event(name="mediaSizeChange",type="org.osmf.events.DisplayObjectEvent")]
	
	/**
	 * Dispatched when a layout target's layoutRenderer property changed.
	 * 
	 * @eventType org.osmf.layout.LayoutTargetEvent.LAYOUT_RENDERER_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="layoutRendererChange",type="org.osmf.layout.LayoutRendererChangeEvent")]
	
	/**
	 * Dispatched when a layout target's parentLayoutRenderer property changed.
	 * 
	 * @eventType org.osmf.layout.LayoutTargetEvent.PARENT_LAYOUT_RENDERER_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="parentLayoutRendererChange",type="org.osmf.layout.LayoutRendererChangeEvent")]

	/**
	 * LayoutContextSprite defines a Sprite based ILayoutContext implementation.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	
	public class LayoutTargetSprite extends Sprite implements ILayoutTarget
	{
		/**
		 * Constructor
		 * 
		 * @param metadata The metadata that an LayoutRenderer may be using on calculating
		 * a layout using this context.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function LayoutTargetSprite(metadata:Metadata=null)
		{
			_metadata = metadata || new Metadata();
			
			_layoutRenderer = new ExternalProperty(this, LayoutRendererChangeEvent.LAYOUT_RENDERER_CHANGE);
			_parentLayoutRenderer = new ExternalProperty(this, LayoutRendererChangeEvent.PARENT_LAYOUT_RENDERER_CHANGE);
		}
		
		// ILayoutTarget
		
		/**
		 * @private
		 */
		public function get metadata():Metadata
		{
			return _metadata;
		}
		
		/**
		 * A reference to this instance.
		 * 
		 * @private
		 */
		public function get displayObject():DisplayObject
		{
			return this;
		}
		
		/**
		 * @private
		 */
		public function get mediaWidth():Number
		{
			return _mediaWidth;
		}
		
		/**
		 * @private
		 */
		public function get mediaHeight():Number
		{
			return _mediaHeight;
		}
		
		/**
		 * @private
		 */	
		public function measureMedia():void
		{
			var newMediaWidth:Number;
			var newMediaHeight:Number;
			
			var layoutRenderer:LayoutRenderer = _layoutRenderer.value as LayoutRenderer;
			
			if (layoutRenderer)
			{
				newMediaWidth = layoutRenderer.mediaWidth;
				newMediaHeight = layoutRenderer.mediaHeight;
			}
				
			if 	(	newMediaWidth != _mediaWidth
				||	newMediaHeight != _mediaHeight
				)
			{
				var event:DisplayObjectEvent
						= new DisplayObjectEvent
							( DisplayObjectEvent.MEDIA_SIZE_CHANGE, false, false
							, null			, null
							, _mediaWidth	, _mediaHeight
							, newMediaWidth	, newMediaHeight
							);
							
				_mediaWidth = newMediaWidth;
				_mediaHeight = newMediaHeight;
				
				dispatchEvent(event);
			}
		}
	 	
	 	/**
		 * @private
		 */
	 	public function updateMediaDisplay(availableWidth:Number, availableHeight:Number):void
	 	{
	 		// Nothing to do: our children get resized by the layout renderer.
	 	}
	 	
	 	/**
		 * @private
		 */		
		public function get layoutRenderer():LayoutRenderer
		{
			return _layoutRenderer.value as LayoutRenderer;
		}
		
		/**
		 * @private
		 */		
		public function get parentLayoutRenderer():LayoutRenderer
		{
			return _parentLayoutRenderer.value as LayoutRenderer;
		}
		
		// Overrides
		//
		
		override public function set width(value:Number):void
		{
			var absoluteLayout:AbsoluteLayoutFacet
				=	_metadata.getFacet(MetadataNamespaces.ABSOLUTE_LAYOUT_PARAMETERS)
				as	AbsoluteLayoutFacet;
			
			if (absoluteLayout == null)
			{
				absoluteLayout = new AbsoluteLayoutFacet();
				absoluteLayout.width = value;
				_metadata.addFacet(absoluteLayout);
			}
			else
			{
				absoluteLayout.width = value;
			} 
		}
		override public function get width():Number
		{
			return _mediaWidth;
		}
		
		override public function set height(value:Number):void
		{
			var absoluteLayout:AbsoluteLayoutFacet
				=	_metadata.getFacet(MetadataNamespaces.ABSOLUTE_LAYOUT_PARAMETERS)
				as	AbsoluteLayoutFacet;
			
			if (absoluteLayout == null)
			{
				absoluteLayout = new AbsoluteLayoutFacet();
				absoluteLayout.height = value;
				_metadata.addFacet(absoluteLayout);
			}
			else
			{
				absoluteLayout.height = value;
			} 
		}
		override public function get height():Number
		{
			return _mediaHeight;
		}
		
		// Internals
		//
		
		private var _metadata:Metadata;
		private var _layoutRenderer:ExternalProperty
		private var _parentLayoutRenderer:ExternalProperty;
		
		private var _mediaWidth:Number = NaN;
		private var _mediaHeight:Number = NaN;
		
		private var _width:Number;
		private var _height:Number;
		
		CONFIG::LOGGING private static const logger:org.osmf.logging.ILogger = org.osmf.logging.Log.getLogger("LayoutTargetSprite");
	}
}