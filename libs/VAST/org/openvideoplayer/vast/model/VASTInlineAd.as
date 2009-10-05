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
*  Contributor(s): Adobe Systems Inc.
* 
*****************************************************/
package org.openvideoplayer.vast.model
{
	/**
	 * This class represents an Inline ad, which is the 
	 * second-level element surrounding complete ad data for a 
	 * single ad in a VAST document.
	 */
	public class VASTInlineAd extends VASTAdPackageBase
	{
		/**
		 * Constructor.
		 */
		public function VASTInlineAd()
		{
			super();

			_companionAds = new Vector.<VASTCompanionAd>();
			_nonLinearAds = new Vector.<VASTNonLinearAd>();
		}

		/**
		 * The ad title.
		 */
		public function get adTitle():String 
		{
			return _adTitle;
		}
		
		public function set adTitle(value:String):void 
		{
			 _adTitle = value;
		}
		
		/**
		 * The description of the ad.
		 */
		public function get description():String 
		{
			return _description;
		}

		public function set description(value:String):void 
		{
			 _description = value;
		}
		
		/**
		 * URL of request to survey vendor.
		 */
		public function get surveyURL():String 
		{
			return _surveyURL;
		}
		
		public function set surveyURL(value:String):void 
		{
			_surveyURL = value;
		}
		
		/**
		 * The video (if any) for the ad.
		 */ 
 		public function get video():VASTVideo 
		{
			return _video;
		}
		
		public function set video(value:VASTVideo):void
		{
			_video = value;
		}		
		
		/**
		 * The collection of VASTCompanionAds within this ad package.
		 */
		public function get companionAds():Vector.<VASTCompanionAd>
		{
			return _companionAds;
		}
		
		/**
		 * The collection of VASTNonLinearAds within this ad package.
		 */
		public function get nonLinearAds():Vector.<VASTNonLinearAd> 
		{
			return _nonLinearAds;
		}
		
		/**
		 * Adds the given VASTCompanionAd to this ad package.
		 */
		public function addCompanionAd(companionAd:VASTCompanionAd):void 
		{
			_companionAds.push(companionAd);
		}
		
		/**
		 * Adds the given VASTNonLinearAd to this ad package.
		 */
		public function addNonLinearAd(nonLinearAd:VASTNonLinearAd):void 
		{
			_nonLinearAds.push(nonLinearAd);
		}

		private var _adTitle:String;
		private var _description:String;
		private var _surveyURL:String;
		private var _video:VASTVideo;
		private var _companionAds:Vector.<VASTCompanionAd>;
		private var	_nonLinearAds:Vector.<VASTNonLinearAd>;
	}
}