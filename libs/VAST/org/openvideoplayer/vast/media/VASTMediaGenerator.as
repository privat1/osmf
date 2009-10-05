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
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.net.NetLoader;
	import org.openvideoplayer.proxies.ProxyElement;
	import org.openvideoplayer.utils.FMSURL;
	import org.openvideoplayer.utils.URL;
	import org.openvideoplayer.vast.model.VASTAd;
	import org.openvideoplayer.vast.model.VASTDocument;
	import org.openvideoplayer.vast.model.VASTInlineAd;
	import org.openvideoplayer.vast.model.VASTMediaFile;
	import org.openvideoplayer.video.VideoElement;
	
	/**
	 * Utility class for creating MediaElements from a VASTDocument.
	 **/
	public class VASTMediaGenerator
	{
		/**
		 * Constructor.
		 * 
		 * @param mediaFileResolver The resolver to use when a VASTDocument
		 * contains multiple representations of the same content (MediaFile).
		 * If null, this object will use a DefaultVASTMediaFileResolver.
		 **/
		public function VASTMediaGenerator(mediaFileResolver:IVASTMediaFileResolver=null)
		{
			super();
			
			this.mediaFileResolver =
				 mediaFileResolver != null
				 ? mediaFileResolver
				 : new DefaultVASTMediaFileResolver();
		}
		
		/**
		 * Creates all relevant MediaElements from the specified VAST document.
		 * 
		 * @param vastDocument The VASTDocument that holds the raw VAST information.
		 * 
		 * @returns A Vector of MediaElements, where each MediaElement
		 * represents a different VASTAd within the VASTDocument. 
		 **/
		public function createMediaElements(vastDocument:VASTDocument):Vector.<MediaElement>
		{
			var mediaElements:Vector.<MediaElement> = new Vector.<MediaElement>();
			
			for each (var vastAd:VASTAd in vastDocument.ads)
			{
				var inlineAd:VASTInlineAd = vastAd.inlineAd;
				if (inlineAd != null)
				{
					// Set up the MediaElement for the ad package.  Note that
					// when we support more than just video ads (e.g. companion
					// and non-linear ads), we should wrap them all in a
					// ParallelElement.
					//
					
					var proxyChain:Vector.<ProxyElement> = new Vector.<ProxyElement>();
					
					// Check for the Impressions.
					if (inlineAd.impressions != null && inlineAd.impressions.length > 0)
					{
						proxyChain.push(new VASTImpressionProxyElement(inlineAd.impressions));
					}
					
					// Check for TrackingEvents.
					if (inlineAd.trackingEvents != null && inlineAd.trackingEvents.length > 0)
					{
						proxyChain.push(new VASTTrackingProxyElement(inlineAd.trackingEvents));
					}
					
					// Check for Video.
					if (inlineAd.video != null)
					{
						// Resolve the correct one.
						var mediaFile:VASTMediaFile = mediaFileResolver.resolveMediaFiles(inlineAd.video.mediaFiles);
						if (mediaFile != null)
						{
							var mediaURL:String = mediaFile.url;
											
							// If streaming, we may need to strip off the extension.
							if (mediaFile.delivery == VASTMediaFile.DELIVERY_STREAMING)
							{
								mediaURL = mediaURL.replace(/\.flv$|\.f4v$/i, "");
							}

							var rootElement:MediaElement = new VideoElement(new NetLoader(), new URLResource(new FMSURL(mediaURL)));
							
							// Resolve the chain of ProxyElements, ensuring that
							// the VideoElement is at the deepest point. 
							for each (var proxyElement:ProxyElement in proxyChain)
							{
								proxyElement.wrappedElement = rootElement;
								rootElement = proxyElement;
							}
							
							mediaElements.push(rootElement);
						}
					}
				}
			}
			
			return mediaElements;
		}
		
		private var mediaFileResolver:IVASTMediaFileResolver;
	}
}