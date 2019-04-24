package edu.rosehulman.wangc6;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.pig.EvalFunc;
import org.apache.pig.FuncSpec;
import org.apache.pig.data.DataType;
import org.apache.pig.data.Tuple;
import org.apache.pig.impl.logicalLayer.FrontendException;
import org.apache.pig.impl.logicalLayer.schema.Schema;

public class Upper extends EvalFunc<String> {

    @Override
    public List<FuncSpec> getArgToFuncMapping() throws FrontendException{
        List<FuncSpec> funcSpecs = new ArrayList<FuncSpec>();
        funcSpecs.add(new FuncSpec(this.getClass().getName(),
                new Schema(new Schema.FieldSchema(null, DataType.CHARARRAY))));
        return funcSpecs;
    }

    @Override
    public String exec(Tuple input) throws IOException {
        // TODO Auto-generated method stub
        if(input == null || input.size() < 1)
            return null;

        Object val = input.get(0);
        return ((String)val).toUpperCase();
    }

}
