@STATIC;1.0;p;6;main.jI;23;Foundation/Foundation.ji;21;objj-analysis-tools.jc;10290;
var _1="main.j",_2="Frameworks";
var _3="Usage: press root_directory output_directory [options]\n        --main path         The relative path (from root_directory) to the main file (default: 'main.j')\n        --frameworks path   The relative path (from root_directory) to the frameworks directory (default: 'Frameworks')\n        --platforms         Platform names, colon separated (default: 'browser:objj')\n        --png               Run pngcrush on all PNGs (pngcrush must be installed!)\n        --flatten           Flatten all code into a single Application.js file and attempt add script tag to index.html (useful for Adobe AIR and CDN deployment)\n        --nostrip           Don't strip any files\n        --v                 Verbose";
main=function(){
var _4=null,_5=null,_6=null,_7=null,_8=["browser","objj"],_9=false,_a=false,_b=false,_c=false;
var _d=false;
while(system.args.length&&!_d){
var _e=system.args.shift();
switch(_e){
case "--main":
if(system.args.length){
_6=system.args.shift();
}else{
_d=true;
}
break;
case "--frameworks":
if(system.args.length){
_7=system.args.shift().replace(/\/$/,"");
}else{
_d=true;
}
break;
case "--platforms":
if(system.args.length){
_8=system.args.shift().split(":");
}else{
_d=true;
}
break;
case "--png":
_9=true;
break;
case "--flatten":
_a=true;
break;
case "--nostrip":
_b=true;
break;
case "--v":
_c=true;
break;
default:
if(_4==null){
_4=_e.replace(/\/$/,"");
}else{
if(_5==null){
_5=_e.replace(/\/$/,"");
}else{
_d=true;
}
}
}
}
if(_c){
CPLogRegister(CPLogPrint);
}else{
CPLogRegisterRange(CPLogPrint,"fatal","info");
}
if(_d||_4==null||_5==null||!_8.length){
print(_3);
return;
}
_4=absolutePath(_4);
var _f=_4+"/"+(_6||_1),_10=_4+"/"+(_7||_2);
CPLog.info("Application root:    "+_4);
CPLog.info("Output directory:    "+_5);
CPLog.info("Main file:           "+_f);
CPLog.info("Frameworks:          "+_10);
var cx=Packages.org.mozilla.javascript.Context.getCurrentContext(),_12=makeObjjScope(cx);
_12.OBJJ_INCLUDE_PATHS=[_10];
_12.OBJJ_PLATFORMS=_8;
var _13=[],_14=[];
_12.objj_search.prototype.didReceiveBundleResponseOriginal=_12.objj_search.prototype.didReceiveBundleResponse;
_12.objj_search.prototype.didReceiveBundleResponse=function(_15){
var _16={success:_15.success,filePath:pathRelativeTo(_15.filePath,_4)};
if(_15.success){
var _17=new Packages.java.io.ByteArrayOutputStream();
outputTransformer(_17,_15.xml,"UTF-8");
_16.text=CPPropertyListCreate280NorthData(CPPropertyListCreateFromXMLData({string:String(_17.toString())})).string;
}
_13.push(_16);
this.didReceiveBundleResponseOriginal.apply(this,arguments);
};
CPLog.error("PHASE 1: Loading application...");
var _18=findGlobalDefines(cx,_12,_f,_14);
var _19=coalesceGlobalDefines(_18);
CPLog.trace("Global defines:");
for(var i in _19){
CPLog.trace("    "+i+" => "+_19[i]);
}
CPLog.error("PHASE 2: Walk dependency tree...");
var _1b={};
if(_b){
_1b=_12.objj_files;
}else{
if(!_12.objj_files[_f]){
CPLog.error("Root file not loaded!");
return;
}
CPLog.warn("Analyzing dependencies...");
var _1c={scope:_12,dependencies:_19,processedFiles:{},ignoreFrameworkImports:true,importCallback:function(_1d,_1e){
_1b[_1e]=true;
},referenceCallback:function(_1f,_20){
_1b[_20]=true;
}};
_1b[_f]=true;
traverseDependencies(_1c,_12.objj_files[_f]);
var _21=0,_22=0;
for(var _23 in _12.objj_files){
if(_1b[_23]){
CPLog.debug("Included: "+_23);
_21++;
}else{
CPLog.info("Excluded: "+_23);
}
_22++;
}
CPLog.warn("Total required files: "+_21+" out of "+_22);
}
var _24={};
if(_a){
CPLog.error("PHASE 3a: Flattening...");
var _25=[],_26=readFile(_4+"/index.html");
var _27=function(_28){
var _29=new objj_bundle();
_29.path=_28.filePath;
if(_28.success){
var _2a=new objj_data();
_2a.string=_28.text;
_29.info=CPPropertyListCreateFrom280NorthData(_2a);
}else{
_29.info=new objj_dictionary();
}
objj_bundles[_28.filePath]=_29;
};
_25.push("var __fakeDidReceiveBundleResponse = "+String(_27));
_25.push("var __fakeBundleArchives = "+JSON.stringify(_13)+";");
_25.push("for (var i = 0; i < __fakeBundleArchives.length; i++) __fakeDidReceiveBundleResponse(__fakeBundleArchives[i]);");
for(var i=0;i<_14.length;i++){
if(_1b[_14[i].file.path]){
_25.push("(function() {");
_25.push("var OBJJ_CURRENT_BUNDLE = objj_bundles['"+pathRelativeTo(_14[i].bundle.path,_4)+"'];");
_25.push(_14[i].info);
_25.push("})();");
}else{
CPLog.info("Stripping "+_14[i].file.path);
}
}
_25.push("if (window.addEventListener)                 window.addEventListener('load', function(){main()}, false);             else if (window.attachEvent)                 window.attachEvent('onload', function(){main()});");
_26=_26.replace(/(\bOBJJ_MAIN_FILE\s*=|\bobjj_import\s*\()/g,"//$&");
_26=_26.replace(/([ \t]*)(<\/head>)/,"$1    <script src = \"Application.js\" type = \"text/javascript\"></script>\n$1$2");
_24[_4+"/Application.js"]=_25.join("\n");
_24[_4+"/index.html"]=_26;
}else{
CPLog.error("PHASE 3b: Rebuild .sj");
var _2b={};
for(var _23 in _1b){
var _2c=_12.objj_files[_23],_2d=basename(_23),_2e=dirname(_23);
if(_2c.path!=_23){
CPLog.warn("Sanity check failed (file path): "+_2c.path+" vs. "+_23);
}
if(_2c.bundle){
var _2f=dirname(_2c.bundle.path);
if(!_2b[_2c.bundle.path]){
_2b[_2c.bundle.path]=_2c.bundle;
}
if(_2f!=_2e){
CPLog.warn("Sanity check failed (directory path): "+_2e+" vs. "+_2f);
}
var _30=_2c.bundle.info,_31=objj_msgSend(_30,"objectForKey:","CPBundleReplacedFiles");
if(_31&&objj_msgSend(_31,"containsObject:",_2d)){
var _32="",_33=objj_msgSend(_30,"objectForKey:","CPBundlePlatforms");
if(_33){
_32=objj_msgSend(_33,"firstObjectCommonWithArray:",_12.OBJJ_PLATFORMS);
if(_32){
_32=_32+".platform/";
}
}
var _34=_2f+"/"+_32+objj_msgSend(_30,"objectForKey:","CPBundleExecutable");
if(!_24[_34]){
_24[_34]=[];
_24[_34].push("@STATIC;1.0;");
}
_24[_34].push("p;");
_24[_34].push(_2d.length+";");
_24[_34].push(_2d);
for(var i=0;i<_2c.fragments.length;i++){
if(_2c.fragments[i].type&FRAGMENT_CODE){
_24[_34].push("c;");
_24[_34].push(_2c.fragments[i].info.length+";");
_24[_34].push(_2c.fragments[i].info);
}else{
if(_2c.fragments[i].type&FRAGMENT_FILE){
var _35=false;
if(_2c.fragments[i].conditionallyIgnore){
var _36=findImportInObjjFiles(_12,_2c.fragments[i]);
if(!_36||!_1b[_36]){
_35=true;
}
}
if(!_35){
if(_2c.fragments[i].type&FRAGMENT_LOCAL){
var _37=pathRelativeTo(_2c.fragments[i].info,_2e);
_24[_34].push("i;");
_24[_34].push(_37.length+";");
_24[_34].push(_37);
}else{
_24[_34].push("I;");
_24[_34].push(_2c.fragments[i].info.length+";");
_24[_34].push(_2c.fragments[i].info);
}
}else{
CPLog.info("Ignoring import fragment "+_2c.fragments[i].info+" in "+_23);
}
}else{
CPLog.error("Unknown fragment type");
}
}
}
}else{
_24[_23]=_2c.contents;
}
}else{
CPLog.warn("No bundle for "+_23);
}
}
CPLog.error("PHASE 3.5: fix bundle plists");
for(var _23 in _2b){
var _2e=dirname(_23),_30=_2b[_23].info,_31=objj_msgSend(_30,"objectForKey:","CPBundleReplacedFiles");
CPLog.info("Modifying .sj: "+_23);
if(_31){
var _38=[];
objj_msgSend(_30,"setObject:forKey:",_38,"CPBundleReplacedFiles");
for(var i=0;i<_31.length;i++){
var _39=_2e+"/"+_31[i];
if(!_1b[_39]){
CPLog.info("Removing: "+_31[i]);
}else{
_38.push(_31[i]);
}
}
}
_24[_23]=CPPropertyListCreateXMLData(_30).string;
}
}
CPLog.error("PHASE 4: copy to output");
var _3a=new Packages.java.io.File(_4),_3b=new Packages.java.io.File(_5);
copyDirectory(_3a,_3b,_9);
for(var _23 in _24){
var _2c=new java.io.File(_3b,pathRelativeTo(_23,_4));
var _3c=_2c.getParentFile();
if(!_3c.exists()){
CPLog.warn(_3c+" doesn't exist, creating directories.");
_3c.mkdirs();
}
CPLog.info("Writing out "+_2c);
var _3d=new java.io.BufferedWriter(new java.io.FileWriter(_2c));
if(typeof _24[_23]=="string"){
_3d.write(_24[_23]);
}else{
_3d.write(_24[_23].join(""));
}
_3d.close();
}
};
copyDirectory=function(src,dst,_40){
CPLog.trace("Copying directory "+src);
dst.mkdirs();
var _41=src.listFiles();
for(var i=0;i<_41.length;i++){
if(_41[i].isFile()){
copyFile(_41[i],new Packages.java.io.File(dst,_41[i].getName()),_40);
}else{
if(_41[i].isDirectory()){
copyDirectory(_41[i],new Packages.java.io.File(dst,_41[i].getName()),_40);
}
}
}
};
copyFile=function(src,dst,_45){
if(_45&&(/.png$/).test(src.getName())){
CPLog.warn("Optimizing .png "+src);
exec(["pngcrush","-rem","alla","-reduce",src.getAbsolutePath(),dst.getAbsolutePath()]);
}else{
CPLog.trace("Copying file "+src);
var _46=(new Packages.java.io.FileInputStream(src)).getChannel(),_47=(new Packages.java.io.FileOutputStream(dst)).getChannel();
_46.transferTo(0,_46.size(),_47);
_46.close();
_47.close();
}
};
dirname=function(_48){
return _48.substring(0,_48.lastIndexOf("/"));
};
basename=function(_49){
return _49.substring(_49.lastIndexOf("/")+1);
};
absolutePath=function(_4a){
return String((new Packages.java.io.File(_4a)).getCanonicalPath());
};
pathRelativeTo=function(_4b,_4c){
var _4d=[],_4e=_4b.split("/"),_4f=_4c?_4c.split("/"):[];
var i=0;
while(i<_4e.length){
if(_4e[i]!=_4f[i]){
break;
}
i++;
}
for(var j=i;j<_4f.length;j++){
_4d.push("..");
}
for(var j=i;j<_4e.length;j++){
_4d.push(_4e[j]);
}
var _52=_4d.join("/");
return _52;
};
exec=function(){
var _53=false;
var _54=Packages.java.lang.Runtime.getRuntime();
var p=_54.exec.apply(_54,arguments);
var _56=new Packages.java.io.BufferedReader(new Packages.java.io.InputStreamReader(p.getInputStream())),_57="",_58=new Packages.java.io.BufferedReader(new Packages.java.io.InputStreamReader(p.getErrorStream())),_59="";
var _5a=false;
while(!_5a){
_5a=true;
if(s=_56.readLine()){
_57+=s;
if(_53){
CPLog.info("exec: "+s);
}
_5a=false;
}
if(s=_58.readLine()){
_59+=s;
CPLog.warn("exec: "+s);
_5a=false;
}
}
var _5b=p.waitFor();
return {code:_5b,stdout:_57,stderr:_59};
};
outputTransformer=function(os,_5d,_5e,_5f){
var _60=new Packages.javax.xml.transform.dom.DOMSource(_5d);
var _61=new Packages.javax.xml.transform.stream.StreamResult(os);
var tf=Packages.javax.xml.transform.TransformerFactory.newInstance();
var _63=tf.newTransformer();
_63.setOutputProperty(Packages.javax.xml.transform.OutputKeys.VERSION,"1.0");
_63.setOutputProperty(Packages.javax.xml.transform.OutputKeys.INDENT,"yes");
if(_5e){
_63.setOutputProperty(Packages.javax.xml.transform.OutputKeys.ENCODING,_5e);
}
if(_5f){
_63.setOutputProperty(Packages.javax.xml.transform.OutputKeys.STANDALONE,(_5f?"yes":"no"));
}
String(_63.transform(_60,_61));
};
p;21;objj-analysis-tools.jc;5539;
var _1=OBJJ_HOME+"/lib/Frameworks/Objective-J/rhino.platform/Objective-J.js",_2=OBJJ_HOME+"/lib/press/bridge.js",_3="/Users/tlrobinson/280North/git/cappuccino/Tools/press/env.js";
traverseDependencies=function(_4,_5){
if(_4.processedFiles[_5.path]){
return;
}
_4.processedFiles[_5.path]=true;
var _6=false;
if(_4.ignoreAllImports){
CPLog.warn("Ignoring all import fragments. ("+_5.path+")");
_6=true;
}else{
if(_4.ignoreFrameworkImports){
var _7=_5.path.match(new RegExp("([^\\/]+)\\/([^\\/]+)\\.j$"));
if(_7&&_7[1]===_7[2]){
CPLog.warn("Framework import file! Ignoring all import fragments. ("+_5.path+")");
_6=true;
}
}
}
if(!_5.fragments){
if(_5.included){
CPLog.warn(_5.path+" is included but missing fragments");
}else{
CPLog.warn("Preprocessing "+_5.path);
}
_5.fragments=objj_preprocess(_5.contents,_5.bundle,_5);
}
if(!_4.bundleImages){
_4.bundleImages={};
}
if(!_4.bundleImages[_5.bundle.path]){
var _8=new java.io.File(dirname(_5.bundle.path)+"/Resources");
if(_8.exists()){
_4.bundleImages[_5.bundle.path]={};
var _9=find(_8,(new RegExp("\\.png$")));
for(var i=0;i<_9.length;i++){
var _b=pathRelativeTo(_9[i].getCanonicalPath(),_8.getCanonicalPath());
_4.bundleImages[_5.bundle.path][_b]=1;
}
}
}
var _c=_4.bundleImages[_5.bundle.path];
var _d={},_e={};
CPLog.debug("Processing "+_5.path+" fragments ("+_5.fragments.length+")");
for(var i=0;i<_5.fragments.length;i++){
var _f=_5.fragments[i];
if(_f.type&FRAGMENT_CODE){
var _10=new objj_lexer(_f.info,NULL);
var _11;
while(_11=_10.skip_whitespace()){
if(_4.dependencies.hasOwnProperty(_11)){
var _12=_4.dependencies[_11];
for(var j=0;j<_12.length;j++){
if(_12[j]!=_5.path){
if(!_d[_12[j]]){
_d[_12[j]]={};
}
_d[_12[j]][_11]=true;
}
}
}
var _7=_11.match(new RegExp("^['\"](.*)['\"]$"));
if(_7&&_c&&_c[_7[1]]){
_c[_7[1]]=(_c[_7[1]]|2);
}
}
}else{
if(_f.type&FRAGMENT_FILE){
if(_6){
_f.conditionallyIgnore=true;
}else{
var _14=findImportInObjjFiles(_4.scope,_f);
if(_14){
if(_14!=_5.path){
_e[_14]=true;
}else{
CPLog.error("Ignoring self import (why are you importing yourself!?): "+_5.path);
}
}else{
CPLog.error("Couldn't find file for import "+_f.info+"("+_f.type+")");
}
}
}
}
}
for(var _14 in _e){
if(_14!=_5.path){
if(_4.importCallback){
_4.importCallback(_5.path,_14);
}
if(_4.scope.objj_files[_14]){
traverseDependencies(_4,_4.scope.objj_files[_14]);
}else{
CPLog.error("Missing imported file: "+_14);
}
}
}
if(_4.importedFiles){
_4.importedFiles[_5.path]=_e;
}
for(var _15 in _d){
if(_15!=_5.path){
if(_4.referenceCallback){
_4.referenceCallback(_5.path,_15,_d[_15]);
}
if(_4.scope.objj_files.hasOwnProperty(_15)){
traverseDependencies(_4,_4.scope.objj_files[_15]);
}else{
CPLog.error("Missing referenced file: "+_15);
}
}
}
if(_4.referencedFiles){
_4.referencedFiles[_5.path]=_d;
}
};
findImportInObjjFiles=function(_16,_17){
var _18=null;
if(_17.type&FRAGMENT_LOCAL){
var _19=_17.info;
if(_16.objj_files[_19]){
_18=_19;
}
}else{
var _1a=_16.OBJJ_INCLUDE_PATHS.length;
while(_1a--){
var _19=_16.OBJJ_INCLUDE_PATHS[_1a].replace(new RegExp("\\/$"),"")+"/"+_17.info;
if(_16.objj_files[_19]){
_18=_19;
break;
}
}
}
return _18;
};
findGlobalDefines=function(_1b,_1c,_1d,_1e){
addMockBrowserEnvironment(_1c);
var _1f=cloneProperties(_1c,true);
_1f["bundle"]=true;
var _20={};
var _21=_1c.fragment_evaluate_file;
_1c.fragment_evaluate_file=function(_22){
return _21(_22);
};
var _23=_1c.fragment_evaluate_code;
_1c.fragment_evaluate_code=function(_24){
CPLog.debug("Evaling "+_24.file.path+" / "+_24.bundle.path);
var _25=cloneProperties(_1c);
if(_1e){
_1e.push(_24);
}
var _26=_23(_24);
var _27={};
diff(_25,_1c,_1f,_27,_27,null);
_20[_24.file.path]=_27;
return _26;
};
runWithScope(_1b,_1c,function(_28){
objj_import(_28,true,NULL);
},[_1d]);
return _20;
};
coalesceGlobalDefines=function(_29){
var _2a={};
for(var _2b in _29){
var _2c=_29[_2b];
for(var _2d in _2c){
if(!_2a[_2d]){
_2a[_2d]=[];
}
_2a[_2d].push(_2b);
}
}
return _2a;
};
makeObjjScope=function(_2e,_2f){
var _30=_2e.initStandardObjects();
if(_2f){
_30.objj_alert=print;
_30.debug=true;
}
_30.print=function(_31){
Packages.java.lang.System.out.println(String(_31));
};
var _32=readFile(_2);
if(_32){
_2e.evaluateString(_30,_32,"bridge.js",1,null);
}else{
CPLog.warn("Missing bridge.js");
}
var _33=readFile(_1);
if(_33){
_2e.evaluateString(_30,_33,"Objective-J.js",1,null);
}else{
CPLog.warn("Missing Objective-J.js");
}
return _30;
};
runWithScope=function(_34,_35,_36,_37){
_35.__runWithScopeArgs=_37||[];
var _38="("+_36+").apply(this, this.__runWithScopeArgs); serviceTimeouts();";
return _34.evaluateString(_35,_38,"<cmd>",1,null);
};
addMockBrowserEnvironment=function(_39){
_39.Element=function(){
this.style={};
};
_39.document={createElement:function(){
return new _39.Element();
}};
};
cloneProperties=function(_3a,_3b){
var _3c={};
for(var _3d in _3a){
_3c[_3d]=_3b?true:_3a[_3d];
}
return _3c;
};
diff=function(_3e,_3f,_40,_41,_42,_43){
for(var i in _3f){
if(_41&&!_40[i]&&typeof _3e[i]=="undefined"){
_41[i]=true;
}
}
for(var i in _3f){
if(_42&&!_40[i]&&typeof _3e[i]!="undefined"&&typeof _3f[i]!="undefined"&&_3e[i]!==_3f[i]){
_42[i]=true;
}
}
for(var i in _3e){
if(_43&&!_40[i]&&typeof _3f[i]=="undefined"){
_43[i]=true;
}
}
};
allKeys=function(_45){
var _46=[];
for(var i in _45){
_46.push(i);
}
return _46.sort();
};
find=function(src,_49){
var _4a=[];
var _4b=src.listFiles();
for(var i=0;i<_4b.length;i++){
if(_4b[i].isFile()&&_49.test(_4b[i].getAbsolutePath())){
_4a.push(_4b[i]);
}else{
if(_4b[i].isDirectory()){
_4a=Array.prototype.concat.apply(_4a,find(_4b[i],_49));
}
}
}
return _4a;
};
