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
package org.osmf.swf
{
	import __AS3__.vec.Vector;
	
	import org.osmf.content.ContentLoader;
	import org.osmf.media.IMediaResource;
	import org.osmf.media.IURLResource;
	import org.osmf.metadata.MediaType;
	import org.osmf.metadata.MetadataUtils;
	
	/**
	 * The SWFLoader class creates a flash.display.Loader object, 
	 * which it uses to load and unload a SWF.
	 * <p>The SWF is loaded from the URL provided by the
	 * <code>resource</code> property of the ILoadable that is passed
	 * to the SWFLoader's <code>load()</code> method.</p>
	 *
	 * @see SWFElement
	 * @see org.osmf.traits.ILoadable
	 * @see flash.display.Loader
	 */ 
	public class SWFLoader extends ContentLoader
	{
		/**
		 * Constructor.
		 * 
		 * @param useCurrentSecurityDomain Indicates whether to load the SWF
		 * into the current security domain, or its natural security domain.
		 * If the loaded SWF does not live in the same security domain as the
		 * loading SWF, Flash Player will not merge the types defined in the two
		 * domains.  Even if it happens that there are two types with identical
		 * names, Flash Player will still consider them different by tagging them
		 * with different versions.  Therefore, it is mandatory to have the
		 * loaded SWF and loading SWF live in the same security domain if the
		 * types need to be merged.
		 */ 
		public function SWFLoader(useCurrentSecurityDomain:Boolean=false)
		{
			super(useCurrentSecurityDomain);
		}
		
		/**
		 * Indicates whether this SWFLoader is capable of handling the specified resource.
		 * Returns <code>true</code> for IURLResources with SWF extensions.
		 * @param resource Resource proposed to be loaded.
		 */ 
		override public function canHandleResource(resource:IMediaResource):Boolean
		{
			var rt:int = MetadataUtils.checkMetadataMatchWithResource(resource, MEDIA_TYPES_SUPPORTED, MIME_TYPES_SUPPORTED);
			if (rt != MetadataUtils.METADATA_MATCH_UNKNOWN)
			{
				return rt == MetadataUtils.METADATA_MATCH_FOUND;
			}			
			
			var urlResource:IURLResource = resource as IURLResource;
			if (urlResource != null &&
				urlResource.url != null)
			{
				return (urlResource.url.path.search(/\.swf$/i) != -1);
			}	
			return false;
		}
		
		// Internals
		//

		private static const MIME_TYPES_SUPPORTED:Vector.<String> = Vector.<String>(["application/x-shockwave-flash"]);
			
		private static const MEDIA_TYPES_SUPPORTED:Vector.<String> = Vector.<String>([MediaType.SWF]);
	}
}