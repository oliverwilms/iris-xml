Class XML.Handler Extends %XML.SAX.ContentHandler
{

// ...

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
