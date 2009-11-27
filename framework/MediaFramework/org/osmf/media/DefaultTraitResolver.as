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
package org.osmf.media
{
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.MediaFrameworkStrings;
	
	/**
	 * Defines a trait resolver that tracks two traits: a default trait
	 * the is set at consturction time, plus one additional trait that
	 * can be set via the addTrait method.
	 * 
	 * For as long as the second trait has not been added, the resolver's
	 * resolved trait will point to the default trait. This changes once
	 * another trait has been added via addTrait: at that point, the
	 * added trait is what the resolver will resolve to.
	 * 
	 * Removing the added trait will re-instate the default trait as the
	 * resolvee.
	 */	
	public class DefaultTraitResolver extends MediaTraitResolver
	{
		/**
		 * Constructor.
		 * 
		 * @param defaultTrait The default trait to resolve to for as long
		 * as no other trait has been added to the resolver.
		 * 
		 * @throws ArgumentError If defaultTrait is null, or if its type does
		 * not match the specified type.
		 */		
		public function DefaultTraitResolver(type:MediaTraitType, defaultTrait:IMediaTrait)
		{
			super(type);
			
			if (defaultTrait == null)
			{
				throw new ArgumentError(MediaFrameworkStrings.NULL_PARAM);
			}
			
			if (defaultTrait is type.traitInterface == false)
			{
				throw new ArgumentError(MediaFrameworkStrings.TRAIT_TYPE_MISMATCH);
			}
			
			this.defaultTrait = defaultTrait;
			setResolvedTrait(defaultTrait);
		}
		
		// Overrides
		//
		
		/**
		 * @inheritDoc
		 * 
		 * Only a single trait can be added to this resolver. Attempting to
		 * add a second will fail. To change the trait, remove the previously
		 * added one first.
		 */		
		override protected function processAddTrait(instance:IMediaTrait):void
		{
			if (trait == null)
			{
				setResolvedTrait(trait = instance);
			}
			else
			{
				CONFIG::LOGGING
				{
					logger.warn("Trait addition ignored by resolver: a non default trait had already been set.");
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function processRemoveTrait(instance:IMediaTrait):IMediaTrait 
		{
			var result:IMediaTrait;
			
			if (instance && instance == trait)
			{
				result = trait;
				trait == null;
				
				setResolvedTrait(defaultTrait);
			}
			
			return result;
		}
		
		// Internals
		//
		
		private var defaultTrait:IMediaTrait;
		private var trait:IMediaTrait;
		
		CONFIG::LOGGING private static const logger:org.osmf.logging.ILogger = org.osmf.logging.Log.getLogger("DefaultTraitResolver");
	}
}