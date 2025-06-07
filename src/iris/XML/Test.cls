Class XML.Test

ClassMethod Write(obj) As %Status
{
    set writer=##class(%XML.Writer).%New()
    set writer.Indent=1

    //these steps are not really needed because 
    //this is the default destination
    set status=writer.OutputToDevice()
    if $$$ISERR(status) {
        do $System.Status.DisplayError(status) 
        quit $$$ERROR($$$GeneralError, "Output destination not valid")
    }

    set status=writer.RootObject(obj)
    if $$$ISERR(status) {
        do $System.Status.DisplayError(status) 
        quit $$$ERROR($$$GeneralError, "Error writing root object")
    }
        
    quit status
}
