package org.osmf.net
{
	import flexunit.framework.TestCase;
	
	import org.osmf.events.LoadEvent;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.manifest.F4MLoader;
	import org.osmf.media.MediaPlayer;
	import org.osmf.media.URLResource;
	import org.osmf.proxies.LoadableProxyElement;
	import org.osmf.traits.LoadState;
	import org.osmf.utils.URL;
	
	public class TestManifestLoader extends TestCase
	{

		public function testDynamicVideoLoad():void
		{
			var loader:F4MLoader = new F4MLoader();			
			var res1:URLResource = new URLResource(new URL('http://flipside.corp.adobe.com/testing/oconnell/manifest/progressive.f4m'));
						
			var finished:Function = addAsync(function():void{}, 3000);
						
			var proxy:LoadableProxyElement = new LoadableProxyElement(loader);
			proxy.resource = res1;
			var player:MediaPlayer = new MediaPlayer();
			player.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoaded);
			player.autoPlay = false;
			player.addEventListener(MediaErrorEvent.MEDIA_ERROR, onLoadedError);
			
			player.element = proxy;
			
			function onLoadedError(event:MediaErrorEvent):void
			{
				assertTrue(false);
			}
			
			function onLoaded(event:LoadEvent):void
			{
				if(event.loadState == LoadState.READY)
				{
					player.element = null;
					finished(null);
				}
			}		
		}

		public function testSingleVideoLoad():void
		{
			var finished:Function = addAsync(function():void{}, 3000);
			
			var loader:F4MLoader = new F4MLoader();			
			var res1:URLResource = new URLResource(new URL('http://flipside/testing/oconnell/manifest/dynamic_Streaming.f4m'));
			var proxy:LoadableProxyElement = new LoadableProxyElement(loader);
			proxy.resource = res1;
			var player:MediaPlayer = new MediaPlayer();
			player.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoaded);
			player.autoPlay = false;
			
			player.addEventListener(MediaErrorEvent.MEDIA_ERROR, onLoadedError);
			
			player.element = proxy;
			
			function onLoadedError(event:MediaErrorEvent):void
			{
				assertTrue(false);
			}
			
			function onLoaded(event:LoadEvent):void
			{
				if(event.loadState == LoadState.READY)
				{
					player.element = null;
					finished(null);
				}
			}	
		}
		
		public function testSingleExternalLoads():void
		{
			var finished:Function = addAsync(function():void{}, 5000);
			
			var loader:F4MLoader = new F4MLoader();			
			var res1:URLResource = new URLResource(new URL('http://flipside/testing/oconnell/manifest/externals.f4m'));
			var proxy:LoadableProxyElement = new LoadableProxyElement(loader);
			proxy.resource = res1;
			var player:MediaPlayer = new MediaPlayer();
			player.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onLoaded);
			player.autoPlay = false;
			player.addEventListener(MediaErrorEvent.MEDIA_ERROR, onLoadedError);
			
			player.element = proxy;
			
			function onLoadedError(event:MediaErrorEvent):void
			{
				assertTrue(false);
			}
			
			function onLoaded(event:LoadEvent):void
			{
				if(event.loadState == LoadState.READY)
				{
					player.element = null;
					finished(null);
				}
			}	
		}


	}
}