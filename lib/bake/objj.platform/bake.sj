@STATIC;1.0;p;6;main.jI;23;Foundation/Foundation.jc;4763;
importPackage(Packages.java.io);
var _1={base:"trunk",clean:false,deploy:false,deployHost:null,deployPath:null,skipUpdate:false,tag:false,archive:false,message:null,templatePath:OBJJ_HOME+"/lib/bake/Resources/bake_template.html"};
var _2,_3,_4,_5,_6=ROUND(new Date().getTime()/1000);
CPLogRegister(CPLogPrint);
readConfig=function(_7){
var _8=String(readFile(_7));
if(!_8){
throw new Error("Couldn't read file: "+_7);
}
var _9=JSON.parse(_8);
return _9;
};
update=function(){
for(var i=0;i<_1.sources.length;i++){
var _b=_1.sources[i];
_b.localSourcePath=_3+"/"+_b.path.replace(/\W+/g,"_");
switch(_b.type){
case "git":
if(new File(_b.localSourcePath).isDirectory()){
CPLog.debug("git pull ("+_b.localSourcePath+")");
exec("git pull",null,new File(_b.localSourcePath));
}else{
CPLog.debug("git clone ("+_b.path+")");
exec(["git","clone",_b.path,_b.localSourcePath]);
}
break;
case "svn":
if(new File(_b.localSourcePath).isDirectory()){
CPLog.debug("svn up ("+_b.localSourcePath+")");
exec("svn up",null,new File(_b.localSourcePath));
}else{
CPLog.debug("svn co ("+_b.path+")");
exec(["svn","co",_b.path,_b.localSourcePath]);
}
break;
case "rsync":
CPLog.debug("rsync ("+_b.localSourcePath+")");
exec(["rsync","-avz",_b.path+"/",_b.localSourcePath]);
break;
default:
CPLog.error("Unimplemented: "+_b.type);
}
}
};
build=function(){
var _c=_5+"/"+_6+"/"+_6;
for(var i=0;i<_1.sources.length;i++){
var _e=_1.sources[i];
for(var j=0;j<_e.parts.length;j++){
var _10=_e.parts[j];
var _11=_e.localSourcePath+"/"+_10.src;
var _12=_c+"/"+_10.dst;
if(_10.build){
var _13=_10.build.replace("$BUILD_PATH",_4);
CPLog.debug("Building: "+_13);
exec(_13,null,new File(_11));
_11=_4+"/"+_10.copyFrom;
}
mkdirs(_12);
var _14="rsync -aC "+_11+"/. "+_12;
CPLog.debug("Rsyncing: "+_14);
exec(_14);
}
}
if(_1.press){
var _15=_c+"-Stripped";
var _16=["press",_c,_15];
if(_1.png){
_16.push("--png");
}
var _17=exec(_16);
if(_17.code){
throw new Error("press failed");
}
exec(["rm","-rf",_c]);
exec(["mv",_15,_c]);
}
var _18=exec(["bash","-c","find "+_c+" \\( -name \"*.sj\" -or -name \"*.j\" \\) -exec cat {} \\; | wc -c | tr -d \" \""]);
var _19=parseInt(_18.stdout);
if(isNaN(_19)){
_19=0;
}
CPLog.debug("FILES_TOTAL=["+_19+"]");
var _1a=_1.templateVars;
_1a.VERSION=_6;
_1a.FILES_TOTAL=_19;
var _1b=readFile(_1.templatePath);
if(!_1b){
throw new Error("Couldn't get template");
}
for(var _1c in _1a){
_1b=_1b.replace(new RegExp("\\$"+_1c,"g"),_1a[_1c]);
}
templateBytes=new java.lang.String(_1b).getBytes();
templateOutput=new FileOutputStream(_5+"/"+_6+"/index.html");
templateOutput.write(templateBytes,0,templateBytes.length);
templateOutput.close();
exec(["tar","czf",_6+".tar.gz",_6],null,new File(_5));
};
deploy=function(){
for(var i=0;i<_1.deployments.length;i++){
var dep=_1.deployments[i];
exec(["scp",_5+"/"+_6+".tar.gz",dep.host+":~/"+_6+".tar.gz"]);
exec(["ssh",dep.host,"tar xzf "+_6+".tar.gz; "+"mkdir -p "+dep.path+"; "+"mv "+_6+"/"+_6+"/ "+dep.path+"/"+_6+"; "+"mv "+_6+"/index.html "+dep.path+"/index.html; "+"rm "+_6+".tar.gz; "+"rmdir "+_6+"; "+"cd "+dep.path+"; "+"ln -nsf "+_6+" Current"]);
}
};
main=function(){
var _1f="bakefile",_20={};
while(args.length){
var arg=args.shift();
switch(arg){
case "--base":
_20.base=args.shift();
break;
case "--tag":
_20.tag=true;
break;
case "--archive":
_20.archive=true;
break;
case "--clean":
_20.clean=true;
break;
case "--deploy":
_20.deploy=true;
break;
case "--press":
_20.press=true;
break;
case "--png":
_20.png=true;
break;
case "--host":
_20.deployHost=args.shift();
break;
case "--path":
_20.deployPath=args.shift();
break;
case "--skip-update":
_20.skipUpdate=true;
break;
case "--message":
_20.message=args.shift();
break;
default:
_1f=arg;
}
}
try{
var _22=readConfig(_1f);
for(var i in _22){
_1[i]=_22[i];
}
for(var i in _20){
_1[i]=_20[i];
}
_2=pwd()+"/"+_1f.match(/^[^\.]+/)[0]+".oven";
mkdirs(_2);
_3=_2+"/Checkouts";
mkdirs(_3);
_4=_2+"/Build";
mkdirs(_4);
_5=_2+"/Products";
mkdirs(_5);
if(!_1.skipUpdate){
CPLog.info("Updating");
update();
}
CPLog.info("Building");
build();
if(_1.deploy){
CPLog.info("Deploying");
deploy();
}
}
catch(e){
CPLog.error(e);
}
};
exec=function(){
var _24=Packages.java.lang.Runtime.getRuntime();
var p=_24.exec.apply(_24,arguments);
var _26="";
var _27=new Packages.java.io.BufferedReader(new Packages.java.io.InputStreamReader(p.getInputStream()));
while(s=_27.readLine()){
_26+=s;
CPLog.info("exec: "+s);
}
var _28="";
var _27=new Packages.java.io.BufferedReader(new Packages.java.io.InputStreamReader(p.getErrorStream()));
while(s=_27.readLine()){
_26+=s;
CPLog.warn("exec: "+s);
}
var _29=p.waitFor();
return {code:_29,stdout:_26,stderr:_28};
};
pwd=function(){
return String(new File("").getAbsolutePath());
};
mkdirs=function(_2a){
return new File(_2a).mkdirs();
};
