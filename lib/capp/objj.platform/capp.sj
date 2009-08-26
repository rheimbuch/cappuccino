@STATIC;1.0;p;15;Configuration.jI;25;Foundation/CPDictionary.jI;21;Foundation/CPString.jI;21;Foundation/CPObject.jc;4456;
var _1=nil,_2=nil,_3=nil;
var _4=objj_allocateClassPair(CPObject,"Configuration"),_5=_4.isa;
class_addIvars(_4,[new objj_ivar("path"),new objj_ivar("dictionary")]);
objj_registerClassPair(_4);
objj_addClassForBundle(_4,objj_getBundleWithPath(OBJJ_CURRENT_BUNDLE.path));
class_addMethods(_4,[new objj_method(sel_getUid("initWithPath:"),function(_6,_7,_8){
with(_6){
_6=objj_msgSendSuper({receiver:_6,super_class:objj_getClass("CPObject")},"init");
if(_6){
path=_8;
dictionary=objj_msgSend(CPDictionary,"dictionary"),temporaryDictionary=objj_msgSend(CPDictionary,"dictionary");
if(_8){
var _9=new java.io.File(objj_msgSend(_6,"path"));
if(_9.canRead()){
try{
var _a=objj_msgSend(CPData,"dataWithString:",readFile(_9.getCanonicalPath())),_b=objj_msgSend(_a,"string");
if(_b&&_b.length){
dictionary=CPPropertyListCreateFromData(_a);
}
}
catch(e){
}
}
}
}
return _6;
}
}),new objj_method(sel_getUid("path"),function(_c,_d){
with(_c){
return path;
}
}),new objj_method(sel_getUid("storedKeyEnumerator"),function(_e,_f){
with(_e){
return objj_msgSend(dictionary,"keyEnumerator");
}
}),new objj_method(sel_getUid("keyEnumerator"),function(_10,_11){
with(_10){
var set=objj_msgSend(CPSet,"setWithArray:",objj_msgSend(dictionary,"allKeys"));
objj_msgSend(set,"addObjectsFromArray:",objj_msgSend(temporaryDictionary,"allKeys"));
objj_msgSend(set,"addObjectsFromArray:",objj_msgSend(_1,"allKeys"));
return objj_msgSend(set,"objectEnumerator");
}
}),new objj_method(sel_getUid("valueForKey:"),function(_13,_14,_15){
with(_13){
var _16=objj_msgSend(dictionary,"objectForKey:",_15);
if(!_16){
_16=objj_msgSend(temporaryDictionary,"objectForKey:",_15);
}
if(!_16){
_16=objj_msgSend(_1,"objectForKey:",_15);
}
return _16;
}
}),new objj_method(sel_getUid("setValue:forKey:"),function(_17,_18,_19,_1a){
with(_17){
objj_msgSend(dictionary,"setObject:forKey:",_19,_1a);
}
}),new objj_method(sel_getUid("setTemporaryValue:forKey:"),function(_1b,_1c,_1d,_1e){
with(_1b){
objj_msgSend(temporaryDictionary,"setObject:forKey:",_1d,_1e);
}
}),new objj_method(sel_getUid("save"),function(_1f,_20){
with(_1f){
if(!objj_msgSend(_1f,"path")){
return;
}
var _21=new BufferedWriter(new FileWriter(new java.io.File(objj_msgSend(_1f,"path"))));
_21.write(objj_msgSend(CPPropertyListCreate280NorthData(dictionary,kCFPropertyListXMLFormat_v1_0),"string"));
_21.close();
}
})]);
class_addMethods(_5,[new objj_method(sel_getUid("initialize"),function(_22,_23){
with(_22){
if(_22!==objj_msgSend(Configuration,"class")){
return;
}
_1=objj_msgSend(CPDictionary,"dictionary");
objj_msgSend(_1,"setObject:forKey:","You","user.name");
objj_msgSend(_1,"setObject:forKey:","you@yourcompany.com","user.email");
objj_msgSend(_1,"setObject:forKey:","Your Company","organization.name");
objj_msgSend(_1,"setObject:forKey:","feedback @nospam@ yourcompany.com","organization.email");
objj_msgSend(_1,"setObject:forKey:","http://yourcompany.com","organization.url");
objj_msgSend(_1,"setObject:forKey:","com.yourcompany","organization.identifier");
var _24=new Date(),_25=["Janurary","February","March","April","May","June","July","August","September","October","November","December"];
objj_msgSend(_1,"setObject:forKey:",_24.getFullYear(),"project.year");
objj_msgSend(_1,"setObject:forKey:",_25[_24.getMonth()]+" "+_24.getDate()+", "+_24.getFullYear(),"project.date");
}
}),new objj_method(sel_getUid("defaultConfiguration"),function(_26,_27){
with(_26){
if(!_2){
_2=objj_msgSend(objj_msgSend(_26,"alloc"),"initWithPath:",nil);
}
return _2;
}
}),new objj_method(sel_getUid("userConfiguration"),function(_28,_29){
with(_28){
if(!_3){
_3=objj_msgSend(objj_msgSend(_28,"alloc"),"initWithPath:",String(new java.io.File(java.lang.System.getProperty("user.home")+"/.cappconfig").getCanonicalPath()));
}
return _3;
}
})]);
config=function(){
var _2a=0,_2b=arguments.length,key=NULL,_2d=NULL,_2e=NO,_2f=NO;
for(;_2a<_2b;++_2a){
var _30=arguments[_2a];
switch(_30){
case "--get":
_2e=YES;
break;
case "-l":
case "--list":
_2f=YES;
break;
default:
if(key===NULL){
key=_30;
}else{
_2d=_30;
}
}
}
var _31=objj_msgSend(Configuration,"userConfiguration");
if(_2f){
var key=nil,_32=objj_msgSend(_31,"storedKeyEnumerator");
while(key=objj_msgSend(_32,"nextObject")){
print(key+"="+objj_msgSend(_31,"valueForKey:",key));
}
}else{
if(_2e){
var _2d=objj_msgSend(_31,"valueForKey:",key);
if(_2d){
print(_2d);
}
}else{
if(key!==NULL&&_2d!==NULL){
objj_msgSend(_31,"setValue:forKey:",_2d,key);
objj_msgSend(_31,"save");
}
}
}
};
p;10;Generate.ji;15;Configuration.jc;3681;
var _1=require("file");
gen=function(){
var _2=0,_3=arguments.length,_4=false,_5=false,_6=false,_7=false,_8="Application",_9="";
for(;_2<_3;++_2){
var _a=arguments[_2];
switch(_a){
case "-l":
_4=true;
break;
case "-t":
case "--template":
_8=arguments[++_2];
break;
case "-f":
case "--frameworks":
_5=true;
break;
case "--noconfig":
_6=true;
break;
case "--force":
_7=true;
break;
default:
_9=_a;
}
}
if(!_5&&_9.length===0){
_9="Untitled";
}
var _b=new java.io.File(OBJJ_HOME+"/lib/capp/Resources/Templates/"+_8),_c=new java.io.File(_9),_d=_6?objj_msgSend(Configuration,"defaultConfiguration"):objj_msgSend(Configuration,"userConfiguration");
if(_5){
createFrameworksInFile(_c,_4,_7);
}else{
if(!_c.exists()){
exec(["cp","-vR",_b.getCanonicalPath(),_c.getCanonicalPath()],true);
var _e=getFiles(_c),_2=0,_3=_e.length,_f=String(_c.getName()),_10=objj_msgSend(_d,"valueForKey:","organization.identifier")||"";
objj_msgSend(_d,"setTemporaryValue:forKey:",_f,"project.name");
objj_msgSend(_d,"setTemporaryValue:forKey:",_10+"."+toIdentifier(_f),"project.identifier");
objj_msgSend(_d,"setTemporaryValue:forKey:",toIdentifier(_f),"project.nameasidentifier");
for(;_2<_3;++_2){
var _11=_e[_2],_12=_1.read(_11,{charset:"UTF-8"}),key=nil,_14=objj_msgSend(_d,"keyEnumerator");
if(_11.indexOf(".gif")!==-1){
continue;
}
while(key=objj_msgSend(_14,"nextObject")){
_12=_12.replace(new RegExp("__"+key+"__","g"),objj_msgSend(_d,"valueForKey:",key));
}
_1.write(_11,_12,{charset:"UTF-8"});
}
createFrameworksInFile(_c,_4);
}else{
print("Directory already exists");
}
}
};
createFrameworksInFile=function(_15,_16,_17){
var _18=new java.io.File(_15.getCanonicalPath()+"/Frameworks"),_19=new java.io.File(_15.getCanonicalPath()+"/Frameworks/Debug");
if(_18.exists()){
if(_17){
print("Updating existing Frameworks directory.");
exec(["rm","-rf",_18.getCanonicalPath()],true);
}else{
print("Frameworks directory already exists. Use --force to overwrite.");
return;
}
}else{
print("Creating Frameworks directory.");
}
if(!_16){
var _1a=new java.io.File(OBJJ_HOME+"/lib/Frameworks");
exec(["cp","-R",_1a.getCanonicalPath(),_18.getCanonicalPath()],true);
return;
}
var _1b=system.env["CAPP_BUILD"]||system.env["STEAM_BUILD"];
if(!_1b){
throw "CAPP_BUILD or STEAM_BUILD must be defined";
}
new java.io.File(_18).mkdir();
exec(["ln","-s",new java.io.File(_1b+"/Release/Objective-J").getCanonicalPath(),new java.io.File(_15.getCanonicalPath()+"/Frameworks/Objective-J").getCanonicalPath()],true);
exec(["ln","-s",new java.io.File(_1b+"/Release/Foundation").getCanonicalPath(),new java.io.File(_15.getCanonicalPath()+"/Frameworks/Foundation").getCanonicalPath()],true);
exec(["ln","-s",new java.io.File(_1b+"/Release/AppKit").getCanonicalPath(),new java.io.File(_15.getCanonicalPath()+"/Frameworks/AppKit").getCanonicalPath()],true);
new java.io.File(_19).mkdir();
exec(["ln","-s",new java.io.File(_1b+"/Debug/Objective-J").getCanonicalPath(),new java.io.File(_15.getCanonicalPath()+"/Frameworks/Debug/Objective-J").getCanonicalPath()],true);
exec(["ln","-s",new java.io.File(_1b+"/Debug/Foundation").getCanonicalPath(),new java.io.File(_15.getCanonicalPath()+"/Frameworks/Debug/Foundation").getCanonicalPath()],true);
exec(["ln","-s",new java.io.File(_1b+"/Debug/AppKit").getCanonicalPath(),new java.io.File(_15.getCanonicalPath()+"/Frameworks/Debug/AppKit").getCanonicalPath()],true);
};
toIdentifier=function(_1c){
var _1d="",_1e=0,_1f=_1c.length,_20=NO,_21=new RegExp("^[a-zA-Z_$]"),_22=new RegExp("^[a-zA-Z_$0-9]");
for(;_1e<_1f;++_1e){
var _23=_1c.charAt(_1e);
if((_1e===0)&&_21.test(_23)||_22.test(_23)){
if(_20){
_1d+=_23.toUpperCase();
}else{
_1d+=_23;
}
_20=NO;
}else{
_20=YES;
}
}
return _1d;
};
p;6;main.jc;151;
importClass(java.io.FileWriter);
importClass(java.io.FileOutputStream);
importClass(java.io.BufferedWriter);
importClass(java.io.OutputStreamWriter);
I;23;Foundation/Foundation.ji;15;Configuration.ji;10;Generate.jc;2754;
main=function(){
if(system.args.length<1){
return printUsage();
}
var _1=0,_2=system.args.length;
for(;_1<_2;++_1){
var _3=system.args[_1];
switch(_3){
case "version":
case "--version":
return print("capp version 0.7.1");
case "-h":
case "--help":
return printUsage();
case "config":
return config.apply(this,system.args.slice(_1+1));
case "gen":
return gen.apply(this,system.args.slice(_1+1));
default:
print("unknown command "+_3);
}
}
};
printUsage=function(){
print("capp [--version] COMMAND [ARGS]");
print("    --version         Print version");
print("    -h, --help        Print usage");
print("");
print(ANSITextApplyProperties("    gen",ANSI_BOLD)+" PATH          Generate new project at PATH from a predefined template");
print("    -l                Symlink the Frameworks folder to your $CAPP_BUILD or $STEAM_BUILD directory");
print("    -t, --template    Specify the template name to use (listed in capp/Resources/Templates)");
print("    -f, --frameworks  Create only frameworks, not a full application");
print("    --force           Overwrite Frameworks directory if it already exists");
print("");
print(ANSITextApplyProperties("    config ",ANSI_BOLD));
print("    name value        Set a value for a given key");
print("    -l, --list        List all variables set in config file.");
print("    --get name        Get the value for a given key");
};
writeContentsToFile=function(_4,_5){
var _6=new BufferedWriter(new FileWriter(_5));
_6.write(_4);
_6.close();
};
exec=function(_7,_8){
var _9="",_a="",_b=Packages.java.lang.Runtime.getRuntime().exec(_7),_c=new Packages.java.io.BufferedReader(new Packages.java.io.InputStreamReader(_b.getInputStream()));
while(_9=_c.readLine()){
if(_8){
Packages.java.lang.System.out.println(_9);
}
_a+=_9+"\n";
}
_c=new Packages.java.io.BufferedReader(new Packages.java.io.InputStreamReader(_b.getErrorStream()));
while(_9=_c.readLine()){
Packages.java.lang.System.out.println(_9);
}
try{
if(_b.waitFor()!=0){
Packages.java.lang.System.err.println("exit value = "+_b.exitValue());
}
}
catch(anException){
Packages.java.lang.System.err.println(anException);
}
return _a;
};
getFiles=function(_d,_e,_f){
var _10=[],_11=_d.listFiles(),_12=typeof _e!=="string";
if(_11){
var _13=0,_14=_11.length;
for(;_13<_14;++_13){
var _15=_11[_13].getCanonicalFile(),_16=String(_15.getName()),_17=!_e;
if(_f&&fileArrayContainsFile(_f,_15)){
continue;
}
if(!_17){
if(_12){
var _18=_e.length;
while(_18--&&!_17){
var _19=_e[_18];
if(_16.substring(_16.length-_19.length-1)===("."+_19)){
_17=true;
}
}
}else{
if(_16.substring(_16.length-_e.length-1)===("."+_e)){
_17=true;
}
}
}
if(_15.isDirectory()){
_10=_10.concat(getFiles(_15,_e,_f));
}else{
if(_17){
_10.push(String(_15.getCanonicalPath()));
}
}
}
}
return _10;
};
