@STATIC;1.0;p;6;main.jI;23;Foundation/Foundation.jI;15;AppKit/AppKit.jI;19;BlendKit/BlendKit.jc;9356;
var File = require("file");
main= function()
{
    var index = 0,
        count = system.args.length,
        outputFilePath = "",
        descriptorFiles = [],
        resourcesPath = nil,
        cibFiles = [],
        blendName = "Untitled";
    for (; index < count; ++index)
    {
        var argument = system.args[index];
        switch (argument)
        {
            case "-c":
            case "--cib": cibFiles.push(system.args[++index]);
                                break;
            case "-d":
            case "-descriptor": descriptorFiles.push(system.args[++index]);
                                break;
            case "-o": outputFilePath = system.args[++index];
                                break;
            case "-R": resourcesPath = system.args[++index];
                                break;
            default: jExtensionIndex = argument.indexOf(".j");
                                if ((jExtensionIndex > 0) && (jExtensionIndex === argument.length - ".j".length))
                                    descriptorFiles.push(argument);
                                else
                                    cibFiles.push(argument);
        }
    }
    if (descriptorFiles.length === 0)
        return buildBlendFromCibFiles(cibFiles);
    objj_import(descriptorFiles, YES, function()
    {
        var themeDescriptorClasses = objj_msgSend(BKThemeDescriptor, "allThemeDescriptorClasses"),
            count = objj_msgSend(themeDescriptorClasses, "count");
        while (count--)
        {
            var theClass = themeDescriptorClasses[count],
                themeTemplate = objj_msgSend(objj_msgSend(BKThemeTemplate, "alloc"), "init");
            objj_msgSend(themeTemplate, "setValue:forKey:", objj_msgSend(theClass, "themeName"), "name");
            var objectTemplates = objj_msgSend(theClass, "themedObjectTemplates"),
                data = cibDataFromTopLevelObjects(objectTemplates.concat([themeTemplate])),
                temporaryCibFile = Packages.java.io.File.createTempFile("temp", ".cib"),
                temporaryCibFilePath = String(temporaryCibFile.getAbsolutePath());
            File.write(temporaryCibFilePath, objj_msgSend(data, "string"), { charset:"UTF-8" });
            cibFiles.push(temporaryCibFilePath);
        }
        buildBlendFromCibFiles(cibFiles, outputFilePath, resourcesPath);
    });
}
cibDataFromTopLevelObjects= function(objects)
{
    var data = objj_msgSend(CPData, "data"),
        archiver = objj_msgSend(objj_msgSend(CPKeyedArchiver, "alloc"), "initForWritingWithMutableData:", data),
        objectData = objj_msgSend(objj_msgSend(_CPCibObjectData, "alloc"), "init");
    objectData._fileOwner = objj_msgSend(_CPCibCustomObject, "new");
    objectData._fileOwner._className = "CPObject";
    var index = 0,
        count = objects.length;
    for (; index < count; ++index)
    {
        objectData._objectsValues[index] = objectData._fileOwner;
        objectData._objectsKeys[index] = objects[index];
    }
    objj_msgSend(archiver, "encodeObject:forKey:", objectData, "CPCibObjectDataKey");
    objj_msgSend(archiver, "finishEncoding");
    return data;
}
getDirectory= function(aPath)
{
    return (aPath).substr(0, (aPath).lastIndexOf('/') + 1)
}
buildBlendFromCibFiles= function(cibFiles, outputFilePath, resourcesPath)
{
    var resourcesFile = nil;
    if (resourcesPath)
        resourcesFile = new Packages.java.io.File(resourcesPath);
    var count = cibFiles.length,
        replacedFiles = [],
        staticContent = "";
    while (count--)
    {
        var theme = themeFromCibFile(new Packages.java.io.File(cibFiles[count])),
            filePath = objj_msgSend(theme, "name") + ".keyedtheme",
            fileContents = objj_msgSend(objj_msgSend(CPKeyedArchiver, "archivedDataWithRootObject:", theme), "string");
        replacedFiles.push(filePath);
        staticContent += MARKER_PATH + ';' + filePath.length + ';' + filePath + MARKER_TEXT + ';' + fileContents.length + ';' + fileContents;
    }
    staticContent = "@STATIC;1.0;" + staticContent;
    var blendName = File.basename(outputFilePath),
        extension = File.extname(outputFilePath);
    if (extension.length)
        blendName = blendName.substr(0, blendName.length - extension.length);
    var infoDictionary = objj_msgSend(CPDictionary, "dictionary"),
        staticContentName = blendName + ".sj";
    objj_msgSend(infoDictionary, "setObject:forKey:", blendName, "CPBundleName");
    objj_msgSend(infoDictionary, "setObject:forKey:", blendName, "CPBundleIdentifier");
    objj_msgSend(infoDictionary, "setObject:forKey:", replacedFiles, "CPBundleReplacedFiles");
    objj_msgSend(infoDictionary, "setObject:forKey:", staticContentName, "CPBundleExecutable");
    var outputFile = new Packages.java.io.File(outputFilePath).getCanonicalFile();
    outputFile.mkdirs();
    File.write(outputFilePath + "/Info.plist", objj_msgSend(CPPropertyListCreate280NorthData(infoDictionary), "string"), { charset:"UTF-8" });
    File.write(outputFilePath + '/' + staticContentName, staticContent, { charset:"UTF-8" });
    if (resourcesPath)
        rsync(new Packages.java.io.File(resourcesPath), new Packages.java.io.File(outputFilePath));
}
themeFromCibFile= function(aFile)
{
    var cib = objj_msgSend(objj_msgSend(CPCib, "alloc"), "initWithContentsOfURL:", aFile.getCanonicalPath()),
        topLevelObjects = [];
    objj_msgSend(cib, "_setAwakenCustomResources:", NO);
    objj_msgSend(cib, "instantiateCibWithExternalNameTable:", objj_msgSend(CPDictionary, "dictionaryWithObject:forKey:", topLevelObjects, CPCibTopLevelObjects));
    var count = topLevelObjects.length,
        theme = nil,
        templates = [];
    while (count--)
    {
        var object = topLevelObjects[count];
        templates = templates.concat(objj_msgSend(object, "blendThemeObjectTemplates"));
        if (objj_msgSend(object, "isKindOfClass:", objj_msgSend(BKThemeTemplate, "class")))
            theme = objj_msgSend(objj_msgSend(CPTheme, "alloc"), "initWithName:", objj_msgSend(object, "valueForKey:", "name"));
    }
    print("Building " + objj_msgSend(theme, "name") + " theme");
    objj_msgSend(templates, "makeObjectsPerformSelector:withObject:", sel_getUid("blendAddThemedObjectAttributesToTheme:"), theme);
    return theme;
}
rsync= function(srcFile, dstFile)
{
    var src, dst;
    if (String(java.lang.System.getenv("OS")).indexOf("Windows") < 0)
    {
        src = srcFile.getAbsolutePath();
        dst = dstFile.getAbsolutePath();
    }
    else
    {
        src = exec(["cygpath", "-u", srcFile.getAbsolutePath() + '/']);
        dst = exec(["cygpath", "-u", dstFile.getAbsolutePath() + "/Resources"]);
    }
    if (srcFile.exists())
        exec(["rsync", "-avz", src, dst]);
}
exec= function( command, showOutput)
{
    var line = "",
        output = "",
        process = Packages.java.lang.Runtime.getRuntime().exec(command),
        reader = new Packages.java.io.BufferedReader(new Packages.java.io.InputStreamReader(process.getInputStream()));
    while (line = reader.readLine())
    {
        if (showOutput)
            System.out.println(line);
        output += line + '\n';
    }
    reader = new Packages.java.io.BufferedReader(new Packages.java.io.InputStreamReader(process.getErrorStream()));
    while (line = reader.readLine())
        System.out.println(line);
    try
    {
        if (process.waitFor() != 0)
            System.err.println("exit value = " + process.exitValue());
    }
    catch (anException)
    {
        System.err.println(anException);
    }
    return output;
}
{
var the_class = objj_getClass("CPObject")
if(!the_class) objj_exception_throw(new objj_exception(OBJJClassNotFoundException, "*** Could not find definition for class \"CPObject\""));
var meta_class = the_class.isa;class_addMethods(the_class, [new objj_method(sel_getUid("blendThemeObjectTemplates"), function(self, _cmd)
{ with(self)
{
    var theClass = objj_msgSend(self, "class");
    if (objj_msgSend(theClass, "isKindOfClass:", objj_msgSend(BKThemedObjectTemplate, "class")))
        return [self];
    if (objj_msgSend(theClass, "isKindOfClass:", objj_msgSend(CPView, "class")))
    {
        var templates = [],
            subviews = objj_msgSend(self, "subviews"),
            count = objj_msgSend(subviews, "count");
        while (count--)
            templates = templates.concat(objj_msgSend(subviews[count], "blendThemeObjectTemplates"));
        return templates;
    }
    return [];
}
})]);
}
{
var the_class = objj_getClass("BKThemedObjectTemplate")
if(!the_class) objj_exception_throw(new objj_exception(OBJJClassNotFoundException, "*** Could not find definition for class \"BKThemedObjectTemplate\""));
var meta_class = the_class.isa;class_addMethods(the_class, [new objj_method(sel_getUid("blendAddThemedObjectAttributesToTheme:"), function(self, _cmd, aTheme)
{ with(self)
{
    var themedObject = objj_msgSend(self, "valueForKey:", "themedObject");
    if (!themedObject)
    {
        var subviews = objj_msgSend(self, "subviews");
        if (objj_msgSend(subviews, "count") > 0)
            themedObject = subviews[0];
    }
    if (themedObject)
    {
        print(" Recording themed properties for " + objj_msgSend(themedObject, "className") + ".");
        objj_msgSend(aTheme, "takeThemeFromObject:", themedObject);
    }
}
})]);
}

