/*!
 * fancyBox - jQuery Plugin
 * version: 2.1.3 (Tue, 23 Oct 2012)
 * @requires jQuery v1.6 or later
 *
 * Examples at http://fancyapps.com/fancybox/
 * License: www.fancyapps.com/fancybox/#license
 *
 * Copyright 2012 Janis Skarnelis - janis@fancyapps.com
 *
 */
(function(e,t,n,r){"use strict";var i=n(e),s=n(t),o=n.fancybox=function(){o.open.apply(this,arguments)},u=null,a=t.createTouch!==r,f=function(e){return e&&e.hasOwnProperty&&e instanceof n},l=function(e){return e&&n.type(e)==="string"},c=function(e){return l(e)&&e.indexOf("%")>0},h=function(e){return e&&(!e.style.overflow||e.style.overflow!=="hidden")&&(e.clientWidth&&e.scrollWidth>e.clientWidth||e.clientHeight&&e.scrollHeight>e.clientHeight)},p=function(e,t){var n=parseInt(e,10)||0;return t&&c(e)&&(n=o.getViewport()[t]/100*n),Math.ceil(n)},d=function(e,t){return p(e,t)+"px"};n.extend(o,{version:"2.1.3",defaults:{padding:15,margin:20,width:800,height:600,minWidth:100,minHeight:100,maxWidth:9999,maxHeight:9999,autoSize:!0,autoHeight:!1,autoWidth:!1,autoResize:!0,autoCenter:!a,fitToView:!0,aspectRatio:!1,topRatio:.5,leftRatio:.5,scrolling:"auto",wrapCSS:"",arrows:!0,closeBtn:!0,closeClick:!1,nextClick:!1,mouseWheel:!0,autoPlay:!1,playSpeed:3e3,preload:3,modal:!1,loop:!0,ajax:{dataType:"html",headers:{"X-fancyBox":!0}},iframe:{scrolling:"auto",preload:!0},swf:{wmode:"transparent",allowfullscreen:"true",allowscriptaccess:"always"},keys:{next:{13:"left",34:"up",39:"left",40:"up"},prev:{8:"right",33:"down",37:"right",38:"down"},close:[27],play:[32],toggle:[70]},direction:{next:"left",prev:"right"},scrollOutside:!0,index:0,type:null,href:null,content:null,title:null,tpl:{wrap:'<div class="fancybox-wrap" tabIndex="-1"><div class="fancybox-skin"><div class="fancybox-outer"><div class="fancybox-inner"></div></div></div></div>',image:'<img class="fancybox-image" src="{href}" alt="" />',iframe:'<iframe id="fancybox-frame{rnd}" name="fancybox-frame{rnd}" class="fancybox-iframe" frameborder="0" vspace="0" hspace="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen'+(n.browser.msie?' allowtransparency="true"':"")+"></iframe>",error:'<p class="fancybox-error">The requested content cannot be loaded.<br/>Please try again later.</p>',closeBtn:'<a title="Close" class="fancybox-item fancybox-close" href="javascript:;"></a>',next:'<a title="Next" class="fancybox-nav fancybox-next" href="javascript:;"><span></span></a>',prev:'<a title="Previous" class="fancybox-nav fancybox-prev" href="javascript:;"><span></span></a>'},openEffect:"fade",openSpeed:250,openEasing:"swing",openOpacity:!0,openMethod:"zoomIn",closeEffect:"fade",closeSpeed:250,closeEasing:"swing",closeOpacity:!0,closeMethod:"zoomOut",nextEffect:"elastic",nextSpeed:250,nextEasing:"swing",nextMethod:"changeIn",prevEffect:"elastic",prevSpeed:250,prevEasing:"swing",prevMethod:"changeOut",helpers:{overlay:!0,title:!0},onCancel:n.noop,beforeLoad:n.noop,afterLoad:n.noop,beforeShow:n.noop,afterShow:n.noop,beforeChange:n.noop,beforeClose:n.noop,afterClose:n.noop},group:{},opts:{},previous:null,coming:null,current:null,isActive:!1,isOpen:!1,isOpened:!1,wrap:null,skin:null,outer:null,inner:null,player:{timer:null,isActive:!1},ajaxLoad:null,imgPreload:null,transitions:{},helpers:{},open:function(e,t){if(!e)return;n.isPlainObject(t)||(t={});if(!1===o.close(!0))return;return n.isArray(e)||(e=f(e)?n(e).get():[e]),n.each(e,function(i,s){var u={},a,c,h,p,d,v,m;n.type(s)==="object"&&(s.nodeType&&(s=n(s)),f(s)?(u={href:s.data("fancybox-href")||s.attr("href"),title:s.data("fancybox-title")||s.attr("title"),isDom:!0,element:s},n.metadata&&n.extend(!0,u,s.metadata())):u=s),a=t.href||u.href||(l(s)?s:null),c=t.title!==r?t.title:u.title||"",h=t.content||u.content,p=h?"html":t.type||u.type,!p&&u.isDom&&(p=s.data("fancybox-type"),p||(d=s.prop("class").match(/fancybox\.(\w+)/),p=d?d[1]:null)),l(a)&&(p||(o.isImage(a)?p="image":o.isSWF(a)?p="swf":a.charAt(0)==="#"?p="inline":l(s)&&(p="html",h=s)),p==="ajax"&&(v=a.split(/\s+/,2),a=v.shift(),m=v.shift())),h||(p==="inline"?a?h=n(l(a)?a.replace(/.*(?=#[^\s]+$)/,""):a):u.isDom&&(h=s):p==="html"?h=a:!p&&!a&&u.isDom&&(p="inline",h=s)),n.extend(u,{href:a,type:p,content:h,title:c,selector:m}),e[i]=u}),o.opts=n.extend(!0,{},o.defaults,t),t.keys!==r&&(o.opts.keys=t.keys?n.extend({},o.defaults.keys,t.keys):!1),o.group=e,o._start(o.opts.index)},cancel:function(){var e=o.coming;if(!e||!1===o.trigger("onCancel"))return;o.hideLoading(),o.ajaxLoad&&o.ajaxLoad.abort(),o.ajaxLoad=null,o.imgPreload&&(o.imgPreload.onload=o.imgPreload.onerror=null),e.wrap&&e.wrap.stop(!0,!0).trigger("onReset").remove(),o.coming=null,o.current||o._afterZoomOut(e)},close:function(e){o.cancel();if(!1===o.trigger("beforeClose"))return;o.unbindEvents();if(!o.isActive)return;!o.isOpen||e===!0?(n(".fancybox-wrap").stop(!0).trigger("onReset").remove(),o._afterZoomOut()):(o.isOpen=o.isOpened=!1,o.isClosing=!0,n(".fancybox-item, .fancybox-nav").remove(),o.wrap.stop(!0,!0).removeClass("fancybox-opened"),o.transitions[o.current.closeMethod]())},play:function(e){var t=function(){clearTimeout(o.player.timer)},r=function(){t(),o.current&&o.player.isActive&&(o.player.timer=setTimeout(o.next,o.current.playSpeed))},i=function(){t(),n("body").unbind(".player"),o.player.isActive=!1,o.trigger("onPlayEnd")},s=function(){o.current&&(o.current.loop||o.current.index<o.group.length-1)&&(o.player.isActive=!0,n("body").bind({"afterShow.player onUpdate.player":r,"onCancel.player beforeClose.player":i,"beforeLoad.player":t}),r(),o.trigger("onPlayStart"))};e===!0||!o.player.isActive&&e!==!1?s():i()},next:function(e){var t=o.current;t&&(l(e)||(e=t.direction.next),o.jumpto(t.index+1,e,"next"))},prev:function(e){var t=o.current;t&&(l(e)||(e=t.direction.prev),o.jumpto(t.index-1,e,"prev"))},jumpto:function(e,t,n){var i=o.current;if(!i)return;e=p(e),o.direction=t||i.direction[e>=i.index?"next":"prev"],o.router=n||"jumpto",i.loop&&(e<0&&(e=i.group.length+e%i.group.length),e%=i.group.length),i.group[e]!==r&&(o.cancel(),o._start(e))},reposition:function(e,t){var r=o.current,i=r?r.wrap:null,s;i&&(s=o._getPosition(t),e&&e.type==="scroll"?(delete s.position,i.stop(!0,!0).animate(s,200)):(i.css(s),r.pos=n.extend({},r.dim,s)))},update:function(e){var t=e&&e.type,n=!t||t==="orientationchange";n&&(clearTimeout(u),u=null);if(!o.isOpen||u)return;u=setTimeout(function(){var r=o.current;if(!r||o.isClosing)return;o.wrap.removeClass("fancybox-tmp"),(n||t==="load"||t==="resize"&&r.autoResize)&&o._setDimension(),(t!=="scroll"||!r.canShrink)&&o.reposition(e),o.trigger("onUpdate"),u=null},n&&!a?0:300)},toggle:function(e){o.isOpen&&(o.current.fitToView=n.type(e)==="boolean"?e:!o.current.fitToView,a&&(o.wrap.removeAttr("style").addClass("fancybox-tmp"),o.trigger("onUpdate")),o.update())},hideLoading:function(){s.unbind(".loading"),n("#fancybox-loading").remove()},showLoading:function(){var e,t;o.hideLoading(),e=n('<div id="fancybox-loading"><div></div></div>').click(o.cancel).appendTo("body"),s.bind("keydown.loading",function(e){(e.which||e.keyCode)===27&&(e.preventDefault(),o.cancel())}),o.defaults.fixed||(t=o.getViewport(),e.css({position:"absolute",top:t.h*.5+t.y,left:t.w*.5+t.x}))},getViewport:function(){var t=o.current&&o.current.locked||!1,n={x:i.scrollLeft(),y:i.scrollTop()};return t?(n.w=t[0].clientWidth,n.h=t[0].clientHeight):(n.w=a&&e.innerWidth?e.innerWidth:i.width(),n.h=a&&e.innerHeight?e.innerHeight:i.height()),n},unbindEvents:function(){o.wrap&&f(o.wrap)&&o.wrap.unbind(".fb"),s.unbind(".fb"),i.unbind(".fb")},bindEvents:function(){var e=o.current,t;if(!e)return;i.bind("orientationchange.fb"+(a?"":" resize.fb")+(e.autoCenter&&!e.locked?" scroll.fb":""),o.update),t=e.keys,t&&s.bind("keydown.fb",function(i){var s=i.which||i.keyCode,u=i.target||i.srcElement;if(s===27&&o.coming)return!1;!i.ctrlKey&&!i.altKey&&!i.shiftKey&&!i.metaKey&&(!u||!u.type&&!n(u).is("[contenteditable]"))&&n.each(t,function(t,u){if(e.group.length>1&&u[s]!==r)return o[t](u[s]),i.preventDefault(),!1;if(n.inArray(s,u)>-1)return o[t](),i.preventDefault(),!1})}),n.fn.mousewheel&&e.mouseWheel&&o.wrap.bind("mousewheel.fb",function(t,r,i,s){var u=t.target||null,a=n(u),f=!1;while(a.length){if(f||a.is(".fancybox-skin")||a.is(".fancybox-wrap"))break;f=h(a[0]),a=n(a).parent()}r!==0&&!f&&o.group.length>1&&!e.canShrink&&(s>0||i>0?o.prev(s>0?"down":"left"):(s<0||i<0)&&o.next(s<0?"up":"right"),t.preventDefault())})},trigger:function(e,t){var r,i=t||o.coming||o.current;if(!i)return;n.isFunction(i[e])&&(r=i[e].apply(i,Array.prototype.slice.call(arguments,1)));if(r===!1)return!1;i.helpers&&n.each(i.helpers,function(t,r){r&&o.helpers[t]&&n.isFunction(o.helpers[t][e])&&(r=n.extend(!0,{},o.helpers[t].defaults,r),o.helpers[t][e](r,i))}),n.event.trigger(e+".fb")},isImage:function(e){return l(e)&&e.match(/(^data:image\/.*,)|(\.(jp(e|g|eg)|gif|png|bmp|webp)((\?|#).*)?$)/i)},isSWF:function(e){return l(e)&&e.match(/\.(swf)((\?|#).*)?$/i)},_start:function(e){var t={},r,i,s,u,f;e=p(e),r=o.group[e]||null;if(!r)return!1;t=n.extend(!0,{},o.opts,r),u=t.margin,f=t.padding,n.type(u)==="number"&&(t.margin=[u,u,u,u]),n.type(f)==="number"&&(t.padding=[f,f,f,f]),t.modal&&n.extend(!0,t,{closeBtn:!1,closeClick:!1,nextClick:!1,arrows:!1,mouseWheel:!1,keys:null,helpers:{overlay:{closeClick:!1}}}),t.autoSize&&(t.autoWidth=t.autoHeight=!0),t.width==="auto"&&(t.autoWidth=!0),t.height==="auto"&&(t.autoHeight=!0),t.group=o.group,t.index=e,o.coming=t;if(!1===o.trigger("beforeLoad")){o.coming=null;return}s=t.type,i=t.href;if(!s)return o.coming=null,o.current&&o.router&&o.router!=="jumpto"?(o.current.index=e,o[o.router](o.direction)):!1;o.isActive=!0;if(s==="image"||s==="swf")t.autoHeight=t.autoWidth=!1,t.scrolling="visible";s==="image"&&(t.aspectRatio=!0),s==="iframe"&&a&&(t.scrolling="scroll"),t.wrap=n(t.tpl.wrap).addClass("fancybox-"+(a?"mobile":"desktop")+" fancybox-type-"+s+" fancybox-tmp "+t.wrapCSS).appendTo(t.parent||"body"),n.extend(t,{skin:n(".fancybox-skin",t.wrap),outer:n(".fancybox-outer",t.wrap),inner:n(".fancybox-inner",t.wrap)}),n.each(["Top","Right","Bottom","Left"],function(e,n){t.skin.css("padding"+n,d(t.padding[e]))}),o.trigger("onReady");if(s==="inline"||s==="html"){if(!t.content||!t.content.length)return o._error("content")}else if(!i)return o._error("href");s==="image"?o._loadImage():s==="ajax"?o._loadAjax():s==="iframe"?o._loadIframe():o._afterLoad()},_error:function(e){n.extend(o.coming,{type:"html",autoWidth:!0,autoHeight:!0,minWidth:0,minHeight:0,scrolling:"no",hasError:e,content:o.coming.tpl.error}),o._afterLoad()},_loadImage:function(){var e=o.imgPreload=new Image;e.onload=function(){this.onload=this.onerror=null,o.coming.width=this.width,o.coming.height=this.height,o._afterLoad()},e.onerror=function(){this.onload=this.onerror=null,o._error("image")},e.src=o.coming.href,e.complete!==!0&&o.showLoading()},_loadAjax:function(){var e=o.coming;o.showLoading(),o.ajaxLoad=n.ajax(n.extend({},e.ajax,{url:e.href,error:function(e,t){o.coming&&t!=="abort"?o._error("ajax",e):o.hideLoading()},success:function(t,n){n==="success"&&(e.content=t,o._afterLoad())}}))},_loadIframe:function(){var e=o.coming,t=n(e.tpl.iframe.replace(/\{rnd\}/g,(new Date).getTime())).attr("scrolling",a?"auto":e.iframe.scrolling).attr("src",e.href);n(e.wrap).bind("onReset",function(){try{n(this).find("iframe").hide().attr("src","//about:blank").end().empty()}catch(e){}}),e.iframe.preload&&(o.showLoading(),t.one("load",function(){n(this).data("ready",1),a||n(this).bind("load.fb",o.update),n(this).parents(".fancybox-wrap").width("100%").removeClass("fancybox-tmp").show(),o._afterLoad()})),e.content=t.appendTo(e.inner),e.iframe.preload||o._afterLoad()},_preloadImages:function(){var e=o.group,t=o.current,n=e.length,r=t.preload?Math.min(t.preload,n-1):0,i,s;for(s=1;s<=r;s+=1)i=e[(t.index+s)%n],i.type==="image"&&i.href&&((new Image).src=i.href)},_afterLoad:function(){var e=o.coming,t=o.current,r="fancybox-placeholder",i,s,u,a,l,c;o.hideLoading();if(!e||o.isActive===!1)return;if(!1===o.trigger("afterLoad",e,t)){e.wrap.stop(!0).trigger("onReset").remove(),o.coming=null;return}t&&(o.trigger("beforeChange",t),t.wrap.stop(!0).removeClass("fancybox-opened").find(".fancybox-item, .fancybox-nav").remove()),o.unbindEvents(),i=e,s=e.content,u=e.type,a=e.scrolling,n.extend(o,{wrap:i.wrap,skin:i.skin,outer:i.outer,inner:i.inner,current:i,previous:t}),l=i.href;switch(u){case"inline":case"ajax":case"html":i.selector?s=n("<div>").html(s).find(i.selector):f(s)&&(s.data(r)||s.data(r,n('<div class="'+r+'"></div>').insertAfter(s).hide()),s=s.show().detach(),i.wrap.bind("onReset",function(){n(this).find(s).length&&s.hide().replaceAll(s.data(r)).data(r,!1)}));break;case"image":s=i.tpl.image.replace("{href}",l);break;case"swf":s='<object id="fancybox-swf" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="100%" height="100%"><param name="movie" value="'+l+'"></param>',c="",n.each(i.swf,function(e,t){s+='<param name="'+e+'" value="'+t+'"></param>',c+=" "+e+'="'+t+'"'}),s+='<embed src="'+l+'" type="application/x-shockwave-flash" width="100%" height="100%"'+c+"></embed></object>"}(!f(s)||!s.parent().is(i.inner))&&i.inner.append(s),o.trigger("beforeShow"),i.inner.css("overflow",a==="yes"?"scroll":a==="no"?"hidden":a),o._setDimension(),o.reposition(),o.isOpen=!1,o.coming=null,o.bindEvents(),o.isOpened?t.prevMethod&&o.transitions[t.prevMethod]():n(".fancybox-wrap").not(i.wrap).stop(!0).trigger("onReset").remove(),o.transitions[o.isOpened?i.nextMethod:i.openMethod](),o._preloadImages()},_setDimension:function(){var e=o.getViewport(),t=0,r=!1,i=!1,s=o.wrap,u=o.skin,a=o.inner,f=o.current,l=f.width,h=f.height,v=f.minWidth,m=f.minHeight,g=f.maxWidth,y=f.maxHeight,b=f.scrolling,w=f.scrollOutside?f.scrollbarWidth:0,E=f.margin,S=p(E[1]+E[3]),x=p(E[0]+E[2]),T,N,C,k,L,A,O,M,_,D,P,H,B,j,I;s.add(u).add(a).width("auto").height("auto").removeClass("fancybox-tmp"),T=p(u.outerWidth(!0)-u.width()),N=p(u.outerHeight(!0)-u.height()),C=S+T,k=x+N,L=c(l)?(e.w-C)*p(l)/100:l,A=c(h)?(e.h-k)*p(h)/100:h;if(f.type==="iframe"){j=f.content;if(f.autoHeight&&j.data("ready")===1)try{j[0].contentWindow.document.location&&(a.width(L).height(9999),I=j.contents().find("body"),w&&I.css("overflow-x","hidden"),A=I.height())}catch(q){}}else if(f.autoWidth||f.autoHeight)a.addClass("fancybox-tmp"),f.autoWidth||a.width(L),f.autoHeight||a.height(A),f.autoWidth&&(L=a.width()),f.autoHeight&&(A=a.height()),a.removeClass("fancybox-tmp");l=p(L),h=p(A),_=L/A,v=p(c(v)?p(v,"w")-C:v),g=p(c(g)?p(g,"w")-C:g),m=p(c(m)?p(m,"h")-k:m),y=p(c(y)?p(y,"h")-k:y),O=g,M=y,f.fitToView&&(g=Math.min(e.w-C,g),y=Math.min(e.h-k,y)),H=e.w-S,B=e.h-x,f.aspectRatio?(l>g&&(l=g,h=p(l/_)),h>y&&(h=y,l=p(h*_)),l<v&&(l=v,h=p(l/_)),h<m&&(h=m,l=p(h*_))):(l=Math.max(v,Math.min(l,g)),f.autoHeight&&f.type!=="iframe"&&(a.width(l),h=a.height()),h=Math.max(m,Math.min(h,y)));if(f.fitToView){a.width(l).height(h),s.width(l+T),D=s.width(),P=s.height();if(f.aspectRatio)while((D>H||P>B)&&l>v&&h>m){if(t++>19)break;h=Math.max(m,Math.min(y,h-10)),l=p(h*_),l<v&&(l=v,h=p(l/_)),l>g&&(l=g,h=p(l/_)),a.width(l).height(h),s.width(l+T),D=s.width(),P=s.height()}else l=Math.max(v,Math.min(l,l-(D-H))),h=Math.max(m,Math.min(h,h-(P-B)))}w&&b==="auto"&&h<A&&l+T+w<H&&(l+=w),a.width(l).height(h),s.width(l+T),D=s.width(),P=s.height(),r=(D>H||P>B)&&l>v&&h>m,i=f.aspectRatio?l<O&&h<M&&l<L&&h<A:(l<O||h<M)&&(l<L||h<A),n.extend(f,{dim:{width:d(D),height:d(P)},origWidth:L,origHeight:A,canShrink:r,canExpand:i,wPadding:T,hPadding:N,wrapSpace:P-u.outerHeight(!0),skinSpace:u.height()-h}),!j&&f.autoHeight&&h>m&&h<y&&!i&&a.height("auto")},_getPosition:function(e){var t=o.current,n=o.getViewport(),r=t.margin,i=o.wrap.width()+r[1]+r[3],s=o.wrap.height()+r[0]+r[2],u={position:"absolute",top:r[0],left:r[3]};return t.autoCenter&&t.fixed&&!e&&s<=n.h&&i<=n.w?u.position="fixed":t.locked||(u.top+=n.y,u.left+=n.x),u.top=d(Math.max(u.top,u.top+(n.h-s)*t.topRatio)),u.left=d(Math.max(u.left,u.left+(n.w-i)*t.leftRatio)),u},_afterZoomIn:function(){var e=o.current;if(!e)return;o.isOpen=o.isOpened=!0,o.wrap.css("overflow","visible").addClass("fancybox-opened"),o.update(),(e.closeClick||e.nextClick&&o.group.length>1)&&o.inner.css("cursor","pointer").bind("click.fb",function(t){!n(t.target).is("a")&&!n(t.target).parent().is("a")&&(t.preventDefault(),o[e.closeClick?"close":"next"]())}),e.closeBtn&&n(e.tpl.closeBtn).appendTo(o.skin).bind(a?"touchstart.fb":"click.fb",function(e){e.preventDefault(),o.close()}),e.arrows&&o.group.length>1&&((e.loop||e.index>0)&&n(e.tpl.prev).appendTo(o.outer).bind("click.fb",o.prev),(e.loop||e.index<o.group.length-1)&&n(e.tpl.next).appendTo(o.outer).bind("click.fb",o.next)),o.trigger("afterShow"),!e.loop&&e.index===e.group.length-1?o.play(!1):o.opts.autoPlay&&!o.player.isActive&&(o.opts.autoPlay=!1,o.play())},_afterZoomOut:function(e){e=e||o.current,n(".fancybox-wrap").trigger("onReset").remove(),n.extend(o,{group:{},opts:{},router:!1,current:null,isActive:!1,isOpened:!1,isOpen:!1,isClosing:!1,wrap:null,skin:null,outer:null,inner:null}),o.trigger("afterClose",e)}}),o.transitions={getOrigPosition:function(){var e=o.current,t=e.element,n=e.orig,r={},i=50,s=50,u=e.hPadding,a=e.wPadding,l=o.getViewport();!n&&e.isDom&&t.is(":visible")&&(n=t.find("img:first"),n.length||(n=t)),f(n)?(r=n.offset(),n.is("img")&&(i=n.outerWidth(),s=n.outerHeight())):(r.top=l.y+(l.h-s)*e.topRatio,r.left=l.x+(l.w-i)*e.leftRatio);if(o.wrap.css("position")==="fixed"||e.locked)r.top-=l.y,r.left-=l.x;return r={top:d(r.top-u*e.topRatio),left:d(r.left-a*e.leftRatio),width:d(i+a),height:d(s+u)},r},step:function(e,t){var n,r,i,s=t.prop,u=o.current,a=u.wrapSpace,f=u.skinSpace;if(s==="width"||s==="height")n=t.end===t.start?1:(e-t.start)/(t.end-t.start),o.isClosing&&(n=1-n),r=s==="width"?u.wPadding:u.hPadding,i=e-r,o.skin[s](p(s==="width"?i:i-a*n)),o.inner[s](p(s==="width"?i:i-a*n-f*n))},zoomIn:function(){var e=o.current,t=e.pos,r=e.openEffect,i=r==="elastic",s=n.extend({opacity:1},t);delete s.position,i?(t=this.getOrigPosition(),e.openOpacity&&(t.opacity=.1)):r==="fade"&&(t.opacity=.1),o.wrap.css(t).animate(s,{duration:r==="none"?0:e.openSpeed,easing:e.openEasing,step:i?this.step:null,complete:o._afterZoomIn})},zoomOut:function(){var e=o.current,t=e.closeEffect,n=t==="elastic",r={opacity:.1};n&&(r=this.getOrigPosition(),e.closeOpacity&&(r.opacity=.1)),o.wrap.animate(r,{duration:t==="none"?0:e.closeSpeed,easing:e.closeEasing,step:n?this.step:null,complete:o._afterZoomOut})},changeIn:function(){var e=o.current,t=e.nextEffect,n=e.pos,r={opacity:1},i=o.direction,s=200,u;n.opacity=.1,t==="elastic"&&(u=i==="down"||i==="up"?"top":"left",i==="down"||i==="right"?(n[u]=d(p(n[u])-s),r[u]="+="+s+"px"):(n[u]=d(p(n[u])+s),r[u]="-="+s+"px")),t==="none"?o._afterZoomIn():o.wrap.css(n).animate(r,{duration:e.nextSpeed,easing:e.nextEasing,complete:function(){setTimeout(o._afterZoomIn,20)}})},changeOut:function(){var e=o.previous,t=e.prevEffect,r={opacity:.1},i=o.direction,s=200;t==="elastic"&&(r[i==="down"||i==="up"?"top":"left"]=(i==="up"||i==="left"?"-":"+")+"="+s+"px"),e.wrap.animate(r,{duration:t==="none"?0:e.prevSpeed,easing:e.prevEasing,complete:function(){n(this).trigger("onReset").remove()}})}},o.helpers.overlay={defaults:{closeClick:!0,speedOut:200,showEarly:!0,css:{},locked:!a,fixed:!0},overlay:null,fixed:!1,create:function(e){e=n.extend({},this.defaults,e),this.overlay&&this.close(),this.overlay=n('<div class="fancybox-overlay"></div>').appendTo("body"),this.fixed=!1,e.fixed&&o.defaults.fixed&&(this.overlay.addClass("fancybox-overlay-fixed"),this.fixed=!0)},open:function(e){var t=this;e=n.extend({},this.defaults,e),this.overlay?this.overlay.unbind(".overlay").width("auto").height("auto"):this.create(e),this.fixed||(i.bind("resize.overlay",n.proxy(this.update,this)),this.update()),e.closeClick&&this.overlay.bind("click.overlay",function(e){n(e.target).hasClass("fancybox-overlay")&&(o.isActive?o.close():t.close())}),this.overlay.css(e.css).show()},close:function(){n(".fancybox-overlay").remove(),i.unbind("resize.overlay"),this.overlay=null,this.margin!==!1&&(n("body").css("margin-right",this.margin),this.margin=!1),this.el&&this.el.removeClass("fancybox-lock")},update:function(){var e="100%",r;this.overlay.width(e).height("100%"),n.browser.msie?(r=Math.max(t.documentElement.offsetWidth,t.body.offsetWidth),s.width()>r&&(e=s.width())):s.width()>i.width()&&(e=s.width()),this.overlay.width(e).height(s.height())},onReady:function(e,r){n(".fancybox-overlay").stop(!0,!0),this.overlay||(this.margin=s.height()>i.height()||n("body").css("overflow-y")==="scroll"?n("body").css("margin-right"):!1,this.el=t.all&&!t.querySelector?n("html"):n("body"),this.create(e)),e.locked&&this.fixed&&(r.locked=this.overlay.append(r.wrap),r.fixed=!1),e.showEarly===!0&&this.beforeShow.apply(this,arguments)},beforeShow:function(e,t){t.locked&&(this.el.addClass("fancybox-lock"),this.margin!==!1&&n("body").css("margin-right",p(this.margin)+t.scrollbarWidth)),this.open(e)},onUpdate:function(){this.fixed||this.update()},afterClose:function(e){this.overlay&&!o.isActive&&this.overlay.fadeOut(e.speedOut,n.proxy(this.close,this))}},o.helpers.title={defaults:{type:"float",position:"bottom"},beforeShow:function(e){var t=o.current,r=t.title,i=e.type,s,u;n.isFunction(r)&&(r=r.call(t.element,t));if(!l(r)||n.trim(r)==="")return;s=n('<div class="fancybox-title fancybox-title-'+i+'-wrap">'+r+"</div>");switch(i){case"inside":u=o.skin;break;case"outside":u=o.wrap;break;case"over":u=o.inner;break;default:u=o.skin,s.appendTo("body"),n.browser.msie&&s.width(s.width()),s.wrapInner('<span class="child"></span>'),o.current.margin[2]+=Math.abs(p(s.css("margin-bottom")))}s[e.position==="top"?"prependTo":"appendTo"](u)}},n.fn.fancybox=function(e){var t,r=n(this),i=this.selector||"",u=function(s){var u=n(this).blur(),a=t,f,l;!(s.ctrlKey||s.altKey||s.shiftKey||s.metaKey)&&!u.is(".fancybox-wrap")&&(f=e.groupAttr||"data-fancybox-group",l=u.attr(f),l||(f="rel",l=u.get(0)[f]),l&&l!==""&&l!=="nofollow"&&(u=i.length?n(i):r,u=u.filter("["+f+'="'+l+'"]'),a=u.index(this)),e.index=a,o.open(u,e)!==!1&&s.preventDefault())};return e=e||{},t=e.index||0,!i||e.live===!1?r.unbind("click.fb-start").bind("click.fb-start",u):s.undelegate(i,"click.fb-start").delegate(i+":not('.fancybox-item, .fancybox-nav')","click.fb-start",u),this.filter("[data-fancybox-start=1]").trigger("click"),this},s.ready(function(){n.scrollbarWidth===r&&(n.scrollbarWidth=function(){var e=n('<div style="width:50px;height:50px;overflow:auto"><div/></div>').appendTo("body"),t=e.children(),r=t.innerWidth()-t.height(99).innerWidth();return e.remove(),r}),n.support.fixedPosition===r&&(n.support.fixedPosition=function(){var e=n('<div style="position:fixed;top:20px;"></div>').appendTo("body"),t=e[0].offsetTop===20||e[0].offsetTop===15;return e.remove(),t}()),n.extend(o.defaults,{scrollbarWidth:n.scrollbarWidth(),fixed:n.support.fixedPosition,parent:n("body")})})})(window,document,jQuery);