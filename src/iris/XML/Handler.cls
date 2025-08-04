Class XML.Handler Extends %XML.SAX.ContentHandler
{

ClassMethod MakeSyncDataFileAttachment(FullFile As %String = "C:\InterSystems\Cache\iris.zip") As %String
{
	Do ..DebugTEST("Oliver.Util - MakeSyncDataFileAttachment")
	If ("" = FullFile) Set FullFile = "C:\HRC\SoftwareUpdates\PRM\prm2.zip"
	Do ..DebugTEST("FullFile = "_FullFile)
	Set DateTime = ##class(Util.Tools).DateTimeIndex($H)
	Set filepath = ##class(%File).GetDirectory(FullFile)
	If (filepath]"") {
		Set rootfile = $Piece(FullFile,filepath,2)
	} Else {
		Set rootfile = FullFile
	}
	Set faobj = ##class(PRM.FileAttachment).%New()
	Set faobj.BinaryContents = ##class(%GlobalBinaryStream).%New()
	Set fileobj = ##class(%Stream.FileBinary).%New()
	Set fasc = fileobj.LinkToFile(FullFile)
	If $$$ISERR(fasc) Do ..DebugStatus(fasc)
	Do faobj.BinaryContents.CopyFrom(fileobj)
	Set x = faobj.BinaryContents.SizeGet()
	Do ..DebugTEST("BinaryContents.Size = "_x)
	Set faobj.IsBinary = 1
	Set faobj.Filename = rootfile
	//Set fasc = faobj.%Save()
	//If $$$ISERR(fasc) Do ..DebugStatus(fasc)
	
	Set writer=##class(%XML.Writer).%New()
	Set writer.Charset="UTF-8"
	Set sc=writer.OutputToString()
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	Set sc=writer.RootElement("RootElement")
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	Set sc=writer.Object(faobj,"FileAttachment")
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	Set sc=writer.EndRootElement()
	If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	//Set sc=writer.OutputToString()
	//If $$$ISERR(sc) Do $system.OBJ.DisplayError(sc) Quit
	Set string=writer.GetXMLString()

	Set tReturn = $Piece(string,"<RootElement>",2)
	Set tReturn = $Piece(tReturn,"</RootElement>",1)
	Quit tReturn
}

ClassMethod ReadFile(file As %String) As %Status
{
    //create an instance of this class
    set handler=..%New()

    //parse the given file using this instance
    set status=##class(%XML.SAX.Parser).ParseFile(file,handler)

    //quit with status
    quit status
}

}
