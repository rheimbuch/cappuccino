@STATIC;1.0;p;6;main.jI;23;Foundation/Foundation.ji;12;OJTestCase.ji;13;OJTestSuite.ji;14;OJTestResult.ji;20;OJTestListenerText.jc;2414;
CPLogRegister(CPLogPrint,"warn");
var _1=objj_allocateClassPair(CPObject,"OJTestRunnerText"),_2=_1.isa;
class_addIvars(_1,[new objj_ivar("_listener")]);
objj_registerClassPair(_1);
objj_addClassForBundle(_1,objj_getBundleWithPath(OBJJ_CURRENT_BUNDLE.path));
class_addMethods(_1,[new objj_method(sel_getUid("init"),function(_3,_4){
with(_3){
if(_3=objj_msgSendSuper({receiver:_3,super_class:objj_getClass("CPObject")},"init")){
_listener=objj_msgSend(objj_msgSend(OJTestListenerText,"alloc"),"init");
}
return _3;
}
}),new objj_method(sel_getUid("getTest:"),function(_5,_6,_7){
with(_5){
var _8=objj_lookUpClass(_7);
if(_8){
var _9=objj_msgSend(objj_msgSend(OJTestSuite,"alloc"),"initWithClass:",_8);
return _9;
}
CPLog.warn("unable to get tests");
return nil;
}
}),new objj_method(sel_getUid("startWithArguments:"),function(_a,_b,_c){
with(_a){
var _d=_c.shift();
if(!_d){
objj_msgSend(_a,"report");
return;
}
var _e=_d.match(/([^\/]+)\.j$/);
print(_e[1]);
var _f=_e[1];
objj_import(_d,YES,function(){
var _10=objj_msgSend(_a,"getTest:",_f);
objj_msgSend(_a,"run:",_10);
objj_msgSend(_a,"startWithArguments:",_c);
});
}
}),new objj_method(sel_getUid("run:wait:"),function(_11,_12,_13,_14){
with(_11){
var _15=objj_msgSend(objj_msgSend(OJTestResult,"alloc"),"init");
objj_msgSend(_15,"addListener:",_listener);
objj_msgSend(_13,"run:",_15);
return _15;
}
}),new objj_method(sel_getUid("run:"),function(_16,_17,_18){
with(_16){
return objj_msgSend(_16,"run:wait:",_18,NO);
}
}),new objj_method(sel_getUid("report"),function(_19,_1a){
with(_19){
var _1b=objj_msgSend(objj_msgSend(_listener,"errors"),"count")+objj_msgSend(objj_msgSend(_listener,"failures"),"count");
if(!_1b){
return CPLog.info("End of all tests.");
}
CPLog.fatal("Test suite failed with "+objj_msgSend(objj_msgSend(_listener,"errors"),"count")+" errors and "+objj_msgSend(objj_msgSend(_listener,"failures"),"count")+" failures.");
}
})]);
class_addMethods(_2,[new objj_method(sel_getUid("runTest:"),function(_1c,_1d,_1e){
with(_1c){
var _1f=objj_msgSend(objj_msgSend(OJTestRunnerText,"alloc"),"init");
objj_msgSend(_1f,"run:",_1e);
}
}),new objj_method(sel_getUid("runClass:"),function(_20,_21,_22){
with(_20){
objj_msgSend(_20,"runTest:",objj_msgSend(objj_msgSend(OJTestSuite,"alloc"),"initWithClass:",_22));
}
})]);
print(args);
runner=objj_msgSend(objj_msgSend(OJTestRunnerText,"alloc"),"init");
objj_msgSend(runner,"startWithArguments:",args);
p;12;OJTestCase.jI;23;Foundation/Foundation.ji;14;OJTestResult.jc;4583;
AssertionFailedError="AssertionFailedError";
var _1=objj_allocateClassPair(CPObject,"OJTestCase"),_2=_1.isa;
class_addIvars(_1,[new objj_ivar("_selector")]);
objj_registerClassPair(_1);
objj_addClassForBundle(_1,objj_getBundleWithPath(OBJJ_CURRENT_BUNDLE.path));
class_addMethods(_1,[new objj_method(sel_getUid("createResult"),function(_3,_4){
with(_3){
return objj_msgSend(objj_msgSend(OJTestResult,"alloc"),"init");
}
}),new objj_method(sel_getUid("run"),function(_5,_6){
with(_5){
var _7=objj_msgSend(_5,"createResult");
objj_msgSend(_5,"run:",_7);
return _7;
}
}),new objj_method(sel_getUid("run:"),function(_8,_9,_a){
with(_8){
objj_msgSend(_a,"run:",_8);
}
}),new objj_method(sel_getUid("runBare"),function(_b,_c){
with(_b){
objj_msgSend(_b,"setUp");
try{
objj_msgSend(_b,"runTest");
}
finally{
objj_msgSend(_b,"tearDown");
}
}
}),new objj_method(sel_getUid("runTest"),function(_d,_e){
with(_d){
objj_msgSend(_d,"assertNotNull:",_selector);
objj_msgSend(_d,"performSelector:",_selector);
}
}),new objj_method(sel_getUid("setUp"),function(_f,_10){
with(_f){
}
}),new objj_method(sel_getUid("tearDown"),function(_11,_12){
with(_11){
}
}),new objj_method(sel_getUid("selector"),function(_13,_14){
with(_13){
return _selector;
}
}),new objj_method(sel_getUid("setSelector:"),function(_15,_16,_17){
with(_15){
_selector=_17;
}
}),new objj_method(sel_getUid("countTestCases"),function(_18,_19){
with(_18){
return 1;
}
}),new objj_method(sel_getUid("assertTrue:"),function(_1a,_1b,_1c){
with(_1a){
objj_msgSend(_1a,"assertTrue:message:",_1c,"expected YES but got NO");
}
}),new objj_method(sel_getUid("assertTrue:message:"),function(_1d,_1e,_1f,_20){
with(_1d){
if(!_1f){
objj_msgSend(_1d,"fail:",_20);
}
}
}),new objj_method(sel_getUid("assertFalse:"),function(_21,_22,_23){
with(_21){
objj_msgSend(_21,"assertFalse:message:",_23,"expected NO but gut YES");
}
}),new objj_method(sel_getUid("assertFalse:message:"),function(_24,_25,_26,_27){
with(_24){
objj_msgSend(_24,"assertTrue:message:",(!_26),_27);
}
}),new objj_method(sel_getUid("assert:equals:"),function(_28,_29,_2a,_2b){
with(_28){
objj_msgSend(_28,"assert:equals:message:",_2a,_2b,nil);
}
}),new objj_method(sel_getUid("assert:equals:message:"),function(_2c,_2d,_2e,_2f,_30){
with(_2c){
if(_2e!==_2f&&!objj_msgSend(_2e,"isEqual:",_2f)){
objj_msgSend(_2c,"failNotEqual:actual:message:",_2e,_2f,_30);
}
}
}),new objj_method(sel_getUid("assert:same:"),function(_31,_32,_33,_34){
with(_31){
objj_msgSend(_31,"assert:same:message:",_33,_34,nil);
}
}),new objj_method(sel_getUid("assert:same:message:"),function(_35,_36,_37,_38,_39){
with(_35){
if(_37!==_38){
objj_msgSend(_35,"failSame:actual:message:",_37,_38,_39);
}
}
}),new objj_method(sel_getUid("assert:notSame:"),function(_3a,_3b,_3c,_3d){
with(_3a){
objj_msgSend(_3a,"assert:notSame:message:",_3c,_3d,nil);
}
}),new objj_method(sel_getUid("assert:notSame:message:"),function(_3e,_3f,_40,_41,_42){
with(_3e){
if(_40===_41){
objj_msgSend(_3e,"failNotSame:actual:message:",_40,_41,_42);
}
}
}),new objj_method(sel_getUid("assertNull:"),function(_43,_44,_45){
with(_43){
objj_msgSend(_43,"assertNull:message:",_45,"expected null but got "+_45);
}
}),new objj_method(sel_getUid("assertNull:message:"),function(_46,_47,_48,_49){
with(_46){
objj_msgSend(_46,"assertTrue:message:",(_48===null),_49);
}
}),new objj_method(sel_getUid("assertNotNull:"),function(_4a,_4b,_4c){
with(_4a){
objj_msgSend(_4a,"assertNotNull:message:",_4c,"expected an object but got null");
}
}),new objj_method(sel_getUid("assertNotNull:message:"),function(_4d,_4e,_4f,_50){
with(_4d){
objj_msgSend(_4d,"assertTrue:message:",(_4f!==null),_50);
}
}),new objj_method(sel_getUid("fail"),function(_51,_52){
with(_51){
objj_msgSend(_51,"fail:",nil);
}
}),new objj_method(sel_getUid("fail:"),function(_53,_54,_55){
with(_53){
objj_msgSend(CPException,"raise:reason:",AssertionFailedError,(_55||"Unknown"));
}
}),new objj_method(sel_getUid("failSame:actual:message:"),function(_56,_57,_58,_59,_5a){
with(_56){
objj_msgSend(_56,"fail:",((_5a?_5a+" ":"")+"expected not same"));
}
}),new objj_method(sel_getUid("failNotSame:actual:message:"),function(_5b,_5c,_5d,_5e,_5f){
with(_5b){
objj_msgSend(_5b,"fail:",((_5f?_5f+" ":"")+"expected same:<"+_5d+"> was not:<"+_5e+">"));
}
}),new objj_method(sel_getUid("failNotEqual:actual:message:"),function(_60,_61,_62,_63,_64){
with(_60){
objj_msgSend(_60,"fail:",((_64?_64+" ":"")+"expected:<"+_62+"> but was:<"+_63+">"));
}
}),new objj_method(sel_getUid("description"),function(_65,_66){
with(_65){
return "["+objj_msgSend(_65,"className")+" "+_selector+"]";
}
})]);
p;15;OJTestFailure.jI;23;Foundation/Foundation.jc;1254;
var _1=objj_allocateClassPair(CPObject,"OJTestFailure"),_2=_1.isa;
class_addIvars(_1,[new objj_ivar("_failedTest"),new objj_ivar("_thrownException")]);
objj_registerClassPair(_1);
objj_addClassForBundle(_1,objj_getBundleWithPath(OBJJ_CURRENT_BUNDLE.path));
class_addMethods(_1,[new objj_method(sel_getUid("initWithTest:exception:"),function(_3,_4,_5,_6){
with(_3){
if(_3=objj_msgSendSuper({receiver:_3,super_class:objj_getClass("CPObject")},"init")){
_failedTest=_5;
_thrownException=_6;
}
return _3;
}
}),new objj_method(sel_getUid("failedTest"),function(_7,_8){
with(_7){
return _failedTest;
}
}),new objj_method(sel_getUid("thrownException"),function(_9,_a){
with(_9){
return _thrownException;
}
}),new objj_method(sel_getUid("description"),function(_b,_c){
with(_b){
return objj_msgSend(_failedTest,"description")+": "+objj_msgSend(_thrownException,"description");
}
}),new objj_method(sel_getUid("trace"),function(_d,_e){
with(_d){
return "Trace not implemented";
}
}),new objj_method(sel_getUid("exceptionMessage"),function(_f,_10){
with(_f){
return objj_msgSend(_thrownException,"description");
}
}),new objj_method(sel_getUid("isFailure"),function(_11,_12){
with(_11){
return objj_msgSend(_thrownException,"name")==AssertionFailedError;
}
})]);
p;20;OJTestListenerText.jI;23;Foundation/Foundation.jc;1289;
var _1=objj_allocateClassPair(CPObject,"OJTestListenerText"),_2=_1.isa;
class_addIvars(_1,[new objj_ivar("_errors"),new objj_ivar("_failures")]);
objj_registerClassPair(_1);
objj_addClassForBundle(_1,objj_getBundleWithPath(OBJJ_CURRENT_BUNDLE.path));
class_addMethods(_1,[new objj_method(sel_getUid("init"),function(_3,_4){
with(_3){
_3=objj_msgSendSuper({receiver:_3,super_class:objj_getClass("CPObject")},"init");
_errors=[];
_failures=[];
return _3;
}
}),new objj_method(sel_getUid("addError:forTest:"),function(_5,_6,_7,_8){
with(_5){
_errors.push(_7);
CPLog.error("addError  test="+objj_msgSend(_8,"description")+" error="+_7);
}
}),new objj_method(sel_getUid("errors"),function(_9,_a){
with(_9){
return _errors;
}
}),new objj_method(sel_getUid("addFailure:forTest:"),function(_b,_c,_d,_e){
with(_b){
_failures.push(_d);
CPLog.warn("addFailure test="+objj_msgSend(_e,"description")+" failure="+_d);
}
}),new objj_method(sel_getUid("failures"),function(_f,_10){
with(_f){
return _failures;
}
}),new objj_method(sel_getUid("startTest:"),function(_11,_12,_13){
with(_11){
CPLog.info("startTest  test="+objj_msgSend(_13,"description"));
}
}),new objj_method(sel_getUid("endTest:"),function(_14,_15,_16){
with(_14){
CPLog.info("endTest    test="+objj_msgSend(_16,"description"));
}
})]);
p;14;OJTestResult.jI;23;Foundation/Foundation.ji;15;OJTestFailure.jc;3088;
var _1=objj_allocateClassPair(CPObject,"OJTestResult"),_2=_1.isa;
class_addIvars(_1,[new objj_ivar("_failures"),new objj_ivar("_errors"),new objj_ivar("_listeners"),new objj_ivar("_runTests"),new objj_ivar("_stop")]);
objj_registerClassPair(_1);
objj_addClassForBundle(_1,objj_getBundleWithPath(OBJJ_CURRENT_BUNDLE.path));
class_addMethods(_1,[new objj_method(sel_getUid("init"),function(_3,_4){
with(_3){
if(_3=objj_msgSendSuper({receiver:_3,super_class:objj_getClass("CPObject")},"init")){
_failures=[];
_errors=[];
_listeners=[];
_runTests=0;
_stop=NO;
}
return _3;
}
}),new objj_method(sel_getUid("addError:forTest:"),function(_5,_6,_7,_8){
with(_5){
objj_msgSend(_failures,"addObject:",objj_msgSend(objj_msgSend(OJTestFailure,"alloc"),"initWithTest:exception:",_8,_7));
for(var i=0;i<_listeners.length;i++){
objj_msgSend(_listeners[i],"addError:forTest:",_7,_8);
}
}
}),new objj_method(sel_getUid("addFailure:forTest:"),function(_a,_b,_c,_d){
with(_a){
objj_msgSend(_errors,"addObject:",objj_msgSend(objj_msgSend(OJTestFailure,"alloc"),"initWithTest:exception:",_d,_c));
for(var i=0;i<_listeners.length;i++){
objj_msgSend(_listeners[i],"addFailure:forTest:",_c,_d);
}
}
}),new objj_method(sel_getUid("startTest:"),function(_f,_10,_11){
with(_f){
_runTests+=objj_msgSend(_11,"countTestCases");
for(var i=0;i<_listeners.length;i++){
objj_msgSend(_listeners[i],"startTest:",_11);
}
}
}),new objj_method(sel_getUid("endTest:"),function(_13,_14,_15){
with(_13){
for(var i=0;i<_listeners.length;i++){
objj_msgSend(_listeners[i],"endTest:",_15);
}
}
}),new objj_method(sel_getUid("run:"),function(_17,_18,_19){
with(_17){
objj_msgSend(_17,"startTest:",_19);
try{
objj_msgSend(_19,"runBare");
}
catch(e){
if(!e.isa){
e=objj_msgSend(CPException,"exceptionWithName:reason:userInfo:",e.name,e.message,nil);
}
if(objj_msgSend(e,"name")==AssertionFailedError){
objj_msgSend(_17,"addFailure:forTest:",e,_19);
}else{
objj_msgSend(_17,"addError:forTest:",e,_19);
}
}
objj_msgSend(_17,"endTest:",_19);
}
}),new objj_method(sel_getUid("addListener:"),function(_1a,_1b,_1c){
with(_1a){
objj_msgSend(_listeners,"addObject:",_1c);
}
}),new objj_method(sel_getUid("removeListener:"),function(_1d,_1e,_1f){
with(_1d){
objj_msgSend(_listeners,"removeObject:",_1f);
}
}),new objj_method(sel_getUid("runCount"),function(_20,_21){
with(_20){
return _runTests;
}
}),new objj_method(sel_getUid("shouldStop"),function(_22,_23){
with(_22){
return _stop;
}
}),new objj_method(sel_getUid("stop"),function(_24,_25){
with(_24){
_stop=YES;
}
}),new objj_method(sel_getUid("failureCount"),function(_26,_27){
with(_26){
return objj_msgSend(_failures,"count");
}
}),new objj_method(sel_getUid("failures"),function(_28,_29){
with(_28){
return _failures;
}
}),new objj_method(sel_getUid("errorCount"),function(_2a,_2b){
with(_2a){
return objj_msgSend(_errors,"count");
}
}),new objj_method(sel_getUid("errors"),function(_2c,_2d){
with(_2c){
return _errors;
}
}),new objj_method(sel_getUid("wasSuccessful"),function(_2e,_2f){
with(_2e){
return objj_msgSend(_2e,"failureCount")==0&&objj_msgSend(_2e,"errorCount")==0;
}
})]);
p;13;OJTestSuite.jI;23;Foundation/Foundation.jc;2989;
var _1=objj_allocateClassPair(CPObject,"OJTestSuite"),_2=_1.isa;
class_addIvars(_1,[new objj_ivar("_tests"),new objj_ivar("_name")]);
objj_registerClassPair(_1);
objj_addClassForBundle(_1,objj_getBundleWithPath(OBJJ_CURRENT_BUNDLE.path));
class_addMethods(_1,[new objj_method(sel_getUid("init"),function(_3,_4){
with(_3){
if(_3=objj_msgSendSuper({receiver:_3,super_class:objj_getClass("CPObject")},"init")){
_tests=[];
}
return _3;
}
}),new objj_method(sel_getUid("initWithName:"),function(_5,_6,_7){
with(_5){
if(_5=objj_msgSend(_5,"init")){
objj_msgSend(_5,"setName:",_7);
}
return _5;
}
}),new objj_method(sel_getUid("initWithClass:"),function(_8,_9,_a){
with(_8){
if(_8=objj_msgSend(_8,"init")){
var _b=_a,_c=[];
while(_b){
var _d=class_copyMethodList(_b);
for(var i=0;i<_d.length;i++){
objj_msgSend(_8,"addTestMethod:names:class:",_d[i].name,_c,_a);
}
_b=_b.super_class;
}
if(objj_msgSend(_tests,"count")==0){
CPLog.warn("No tests");
}
}
return _8;
}
}),new objj_method(sel_getUid("initWithClass:name:"),function(_f,_10,_11,_12){
with(_f){
objj_msgSend(_f,"initWithClass:",_11);
objj_msgSend(_f,"setName:",_12);
}
}),new objj_method(sel_getUid("addTest:"),function(_13,_14,_15){
with(_13){
objj_msgSend(_tests,"addObject:",_15);
}
}),new objj_method(sel_getUid("addTestSuite:"),function(_16,_17,_18){
with(_16){
objj_msgSend(_16,"addTest:",objj_msgSend(objj_msgSend(OJTestSuite,"alloc"),"initWithClass:",_18));
}
}),new objj_method(sel_getUid("addTestMethod:names:class:"),function(_19,_1a,_1b,_1c,_1d){
with(_19){
if(objj_msgSend(_1c,"containsObject:",_1b)||!objj_msgSend(_19,"isTestMethod:",_1b)){
return;
}
objj_msgSend(_1c,"addObject:",_1b);
objj_msgSend(_19,"addTest:",objj_msgSend(_19,"createTestWithSelector:class:",_1b,_1d));
}
}),new objj_method(sel_getUid("createTestWithSelector:class:"),function(_1e,_1f,_20,_21){
with(_1e){
var _22=objj_msgSend(_1e,"getTestConstructor:",_21);
var _23;
if(_20.indexOf(":")<0){
_23=objj_msgSend(objj_msgSend(_21,"alloc"),"performSelector:",_22);
if(objj_msgSend(_23,"isKindOfClass:",objj_msgSend(OJTestCase,"class"))){
objj_msgSend(_23,"setSelector:",_20);
}
}else{
_23=objj_msgSend(_21,"performSelector:withObject:",_22,_20);
}
return _23;
}
}),new objj_method(sel_getUid("isTestMethod:"),function(_24,_25,_26){
with(_24){
return _26.substring(0,4)=="test"&&_26.indexOf(":")==-1;
}
}),new objj_method(sel_getUid("getTestConstructor:"),function(_27,_28,_29){
with(_27){
return "init";
}
}),new objj_method(sel_getUid("run:"),function(_2a,_2b,_2c){
with(_2a){
for(var i=0;i<_tests.length;i++){
if(objj_msgSend(_2c,"shouldStop")){
break;
}
objj_msgSend(_tests[i],"run:",_2c);
}
}
}),new objj_method(sel_getUid("name"),function(_2e,_2f){
with(_2e){
return _name;
}
}),new objj_method(sel_getUid("setName:"),function(_30,_31,_32){
with(_30){
_name=_32;
}
}),new objj_method(sel_getUid("countTestCases"),function(_33,_34){
with(_33){
var _35=0;
for(var i=0;i<_tests.length;i++){
objj_msgSend(_tests[i],"countTestCases");
}
return _35;
}
})]);
