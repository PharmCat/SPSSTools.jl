module SPSSTools

using Tables

export value_labels

"""
    value_labels(data, value::Symbol, label::Symbol; varname = "varname", out = nothing, charq = :auto)

VALUE LABELS command with value-label pairs from data table.

* `charq` - character quoting, `:auto` or Tuple{Bool, Bool}

Example:

 `value_labels(data, :value, :label; varname = "name",  charq = (false, true))`

Pattern:

VALUE LABELS
varname
val1 'label1'
val2 'label2'
val3 'label3'.
EXECUTE.
"""
function value_labels(data, value::Symbol, label::Symbol; varname = "varname", out = nothing, charq = :auto)
    cols = Tables.columns(data)
    res  = Tuple(Tables.getcolumn(cols, y) for y in (value, label))
    str = "VALUE LABELS \n$(varname)"
    if isa(charq, Symbol) && charq == :auto
        if eltype(res[1]) <: Number
            valstr = ""
        else
            valstr = "'"
        end
        if eltype(res[2]) <: Number
            labstr = ""
        else
            labstr = "'"
        end
    else
        if charq[1] == true valstr = "'" else valstr = "" end
        if charq[2] == true labstr = "'" else labstr = "" end
    end
    for i = 1:length(res[1])
        str = str * "\n$valstr$(res[1][i])$valstr $labstr$(res[2][i])$labstr"
    end
    str = str * ".\nEXECUTE."
    str
end

end # module
