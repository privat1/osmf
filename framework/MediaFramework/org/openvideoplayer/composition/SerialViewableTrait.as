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
package org.openvideoplayer.composition
{
	import org.openvideoplayer.events.GatewayChangeEvent;
	import org.openvideoplayer.events.ViewChangeEvent;
	import org.openvideoplayer.layout.MediaElementLayoutTarget;
	import org.openvideoplayer.media.IMediaGateway;
	import org.openvideoplayer.media.MediaElement;

	/**
	 * Dispatched when the trait's view has changed.
	 * 
	 * @eventType org.openvideoplayer.events.ViewChangeEvent.VIEW_CHANGE
	 */	
	[Event(name="viewChange",type="org.openvideoplayer.events.ViewChangeEvent")]
	
	/**
	 * Implements IViewable for serial compositions
	 * 
	 * The viewable characteristics of a serial composition are identical to the viewable
	 * characteristics of the active child of that serial composition.
	 * 
	 */	
	internal class SerialViewableTrait extends CompositeViewableTrait implements IReusable
	{
		/**
		 * Constructor
		 */		
		public function SerialViewableTrait(traitAggregator:TraitAggregator, owner:MediaElement)
		{
			this.owner = owner;
			
			super(traitAggregator, owner);
			
			// In order to forward the serial's active child's view, we need
			// to track the serial's active child:
			traitAggregator.addEventListener
				( TraitAggregatorEvent.LISTENED_CHILD_CHANGE
				, onListenedChildChange
				);
			
			// Setup the current active child:
			setupLayoutTarget(traitAggregator.listenedChild);
		}
		
		// IReusable
		//
		
		public function prepare():void
		{	
			attach();
		}
		
		// Internals
		//
		
		/**
		 * Invoked on the serial's active child changing.
		 */		
		private function onListenedChildChange(event:TraitAggregatorEvent):void
		{
			setupLayoutTarget(event.newListenedChild);
		}
		
		private function onTargetGatewayChange(event:GatewayChangeEvent):void
		{
			var oldGateway:IMediaGateway = event.oldValue;
			var newGateway:IMediaGateway = event.newValue;
			var element:MediaElement = layoutTarget.mediaElement;
		
			
			var targetInLayoutRenderer:Boolean
				= layoutRenderer.targets(layoutTarget);
				
			if (newGateway == null || newGateway == owner.gateway)
			{
				if (targetInLayoutRenderer == false)
				{
					layoutRenderer.addTarget(layoutTarget);
				}
			}
			else
			{ 
				if (targetInLayoutRenderer)
				{
					layoutRenderer.removeTarget(layoutTarget);
				}
			}
		}
		
		private function setupLayoutTarget(listenedChild:MediaElement):void
		{
			if (layoutTarget != null)
			{
				layoutTarget.mediaElement.removeEventListener
					( GatewayChangeEvent.GATEWAY_CHANGE
					, onTargetGatewayChange
					);
				
				var mediaElement:MediaElement = layoutTarget.mediaElement;
					
				if (layoutRenderer.targets(layoutTarget))
				{
					layoutRenderer.removeTarget(layoutTarget);
				}
			}
			
			if (listenedChild != null)
			{
				layoutTarget = new MediaElementLayoutTarget(listenedChild);
				
				listenedChild.addEventListener
					( GatewayChangeEvent.GATEWAY_CHANGE
					, onTargetGatewayChange
					);
					
				onTargetGatewayChange
					( new GatewayChangeEvent
						( null
						, layoutTarget.mediaElement.gateway
						)
					);
			}
		}
		
		private var layoutTarget:MediaElementLayoutTarget;
		private var owner:MediaElement;
	}
}