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
*****************************************************/
package org.osmf.smil.parser
{
	import org.osmf.logging.ILogger;
	import org.osmf.logging.Log;
	import org.osmf.smil.model.SMILDocument;
	import org.osmf.smil.model.SMILElement;
	import org.osmf.smil.model.SMILElementType;
	import org.osmf.smil.model.SMILMediaElement;
	import org.osmf.smil.model.SMILMetaElement;
	import org.osmf.utils.TimeUtil;
	import org.osmf.utils.URL;	
	
	/**
	 * Parses a SMIL file and creates a document object
	 * model.
	 */
	public class SMILParser
	{
		/**
		 * Parses a SMIL file and returns a <code>SMILDocument</code>.
		 */
		public function parse(rawData:String):SMILDocument
		{
			if (rawData == null || rawData == "")
			{
				throw new ArgumentError();
			}
			
			var xml:XML = new XML(rawData);
			var smilDocument:SMILDocument = new SMILDocument();
			
			parseHead(smilDocument, xml);
			parseBody(smilDocument, xml);
			
			return smilDocument;
		}
		
		/**
		 * Override to provide custom formatting of bitrate
		 * values. 
		 */
		protected function formatBitrate(value:String):Number
		{
			var bitrate:Object = null;
			
			if ((value != null) && (value.length > 0))
			{
				bitrate = Number(value)/1000;
			}
			
			return Number(bitrate);
		}
		
		private function parseHead(doc:SMILDocument, xml:XML):void
		{
			var ns:Namespace = xml.namespace();
			var head:XMLList = xml..ns::head;
			
			if (head.length() > 0)
			{
				parseElement(doc, head.children());
			}
			
		}
		
		private function parseBody(doc:SMILDocument, xml:XML):void
		{
			var ns:Namespace = xml.namespace();
			var body:XMLList = xml..ns::body;
			
			// The <body> tag is required
			if (body.length() <= 0)
			{
				debugLog("Invalid SMIL file: <body> tag is missing.");
			}
			else
			{
				parseElement(doc, body.children());
			}
		}
		
		private function parseElement(doc:SMILDocument, children:XMLList, parent:SMILElement=null):void
		{
			for (var i:uint = 0; i < children.length(); i++)
			{
				var childNode:XML = children[i];
				var element:SMILElement;
				
				switch (childNode.nodeKind())
				{
					case "element":
						switch (childNode.localName())
						{
							case SMILElementType.SEQUENCE:
								element = new SMILElement(SMILElementType.SEQUENCE);
								break;
							case SMILElementType.PARALLEL:
								element = new SMILElement(SMILElementType.PARALLEL);
								break;
							case SMILElementType.SWITCH:
								element = new SMILElement(SMILElementType.SWITCH);
								break;
							case SMILElementType.IMAGE:
							case SMILElementType.VIDEO:
								element = parseMediaElement(childNode);
								break;
							case SMILElementType.META:
								element = parseMetaElement(childNode);
								break;
						}
						break;
				}
				
				parseElement(doc, childNode.children(), element);
				if (parent != null)
				{
					parent.addChild(element);
				}
				else
				{
					doc.addElement(element);
				}
			}	
		}
		
		private function parseMediaElement(node:XML):SMILMediaElement
		{
			var element:SMILMediaElement;
			
			switch (node.nodeKind())
			{
				case "element":
					switch (node.localName())
					{
						case SMILElementType.VIDEO:
							element = new SMILMediaElement(SMILElementType.VIDEO);
							element.src = node.@[ATTRIB_SOURCE];
							element.bitrate = formatBitrate(node.@[ATTRIB_BITRATE]);
							if (node.@dur != null)
							{
								element.duration = TimeUtil.parseTime(node.@[ATTRIB_DURATION]);
							} 
							break;
					}
					break;
			}
			
			return element;
		}
		
		private function parseMetaElement(node:XML):SMILMetaElement
		{
			var element:SMILMetaElement;
			
			switch (node.nodeKind())
			{
				case "element":
					switch (node.localName())
					{
						case SMILElementType.META:
							element = new SMILMetaElement();
							element.base = new URL(node.@[ATTRIB_META_BASE]);
							break;
					}
					break;
			}
			
			return element;
		}
		
		private function debugLog(msg:String):void
		{
			CONFIG::LOGGING
			{
				if (logger != null)
				{
					logger.debug(msg);
				}
			}
		}
		
		CONFIG::LOGGING
		{
			private static const logger:ILogger = org.osmf.logging.Log.getLogger("SMILParser");
		}
		
		private static const ATTRIB_SOURCE:String = "src";
		private static const ATTRIB_BITRATE:String = "system-bitrate";
		private static const ATTRIB_DURATION:String = "dur";
		private static const ATTRIB_META_BASE:String = "base";
	}
}
