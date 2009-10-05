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
package org.openvideoplayer.metadata
{
	import __AS3__.vec.Vector;
	
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import org.openvideoplayer.events.MetadataEvent;
	import org.openvideoplayer.utils.MediaFrameworkStrings;
	import org.openvideoplayer.utils.URL;
	
	/**
	 * Dispatched when the an IMetadata has been added.
	 * 
	 * @eventType org.openvideoplayer.events.MetadataEvent.FACET_ADD
	 */	
	[Event(name="facetAdd",type="org.openvideoplayer.events.MetadataEvent")]
	
	/**
	 * Dispatched when the an IMetadata has been removed.
	 * 
	 * @eventType org.openvideoplayer.events.MetadataEvent.FACET_REMOVE
	 */	
	[Event(name="facetRemove",type="org.openvideoplayer.events.MetadataEvent")]
	
	/**
	 *  The Metadata collection is the default implementation for metadata carrying media.
	 */ 
	public class Metadata extends EventDispatcher
	{		 
			
		/** 
		 * @returns the facet of the given type, for data of the given namespace,
		 * null if none exists.  The result can be cast to the class represented
		 * by FacetType (similar to how we cast traits after calling getTrait).
		 * Null if a facet doesn't exist at the specified index
		 */ 
		public function getFacet(nameSpace:URL):IFacet
		{				
			return _list[nameSpace.rawUrl] as IFacet;			
		}
		
		/** 
		 * Returns adds a facet of the given type for data of the given namespace.
		 * Will overwrite an existing Facet (acts as update), with the same type and same namespace.
		 * 
		 * @param value the facet to add
		 * 
		 * @throws IllegalOperation if the data or namespace is null.
		 */ 
		public function addFacet(data:IFacet):void
		{
			if (data == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
				return;
			}
			if (data.namespaceURL == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NAMESPACE_MUST_NOT_BE_EMPTY);
				return;
			}	
			var oldFacet:IFacet = _list[data.namespaceURL.rawUrl];			
			_list[data.namespaceURL.rawUrl] = data;
			if(oldFacet)
			{
				dispatchEvent(new MetadataEvent(oldFacet, MetadataEvent.FACET_REMOVE));		
			}	
			dispatchEvent(new MetadataEvent(data, MetadataEvent.FACET_ADD));							
		}
		
		/**
		 * Removes the given facet from the specified namespace.  
		 * 
		 * @param The facet to remove.
		 * 
		 * @returns The removed facet.  Null if value is not in this IMetadata.
		 * 
		 * @throws IllegalOperation if the data or namespace is null.
		 */ 
		public function removeFacet(data:IFacet):IFacet
		{		
			if (data == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
				return;
			}
			if (data.namespaceURL == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NAMESPACE_MUST_NOT_BE_EMPTY);
				return;
			}	
			if (_list[data.namespaceURL.rawUrl])
			{			
				delete _list[data.namespaceURL.rawUrl];	
				dispatchEvent(new MetadataEvent(data, MetadataEvent.FACET_REMOVE));	
				return data;					
			}				
			return null;
		}	
			
		/**
		 * Gets the namespaces that valid facets are stored in.
		 * 
		 * @returns The a list of all valid namespaces
		 *
		 */ 
		public function get namespaceURLs():Vector.<String>
		{
			var spaces:Vector.<String> = new Vector.<String>;
			for ( var ns:String in _list)
			{
				spaces.push(ns);
			}			
			return spaces;
		}
			
		private var _list:Dictionary = new Dictionary();	
	}
}