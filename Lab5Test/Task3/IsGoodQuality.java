package edu.rosehulman.wangc6;

import org.apache.pig.FilterFunc;
import org.apache.pig.FuncSpec;
import org.apache.pig.data.DataType;
import org.apache.pig.data.Tuple;
import org.apache.pig.impl.logicalLayer.FrontendException;
import org.apache.pig.impl.logicalLayer.schema.Schema;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class IsGoodQuality extends FilterFunc {

	public List<FuncSpec> getArgToFuncMapping() throws FrontendException {
		List<FuncSpec> funcSpecs = new ArrayList<FuncSpec>();
		funcSpecs.add(
				new FuncSpec(this.getClass().getName(), new Schema(new Schema.FieldSchema(null, DataType.INTEGER))));
		return funcSpecs;
	}

	public Boolean exec(Tuple input) throws IOException {
		if (input == null || input.size() == 0) {
			return false;
		}
		Object val = input.get(0);
		if (val == null) {
			return false;
		}
		int i = (Integer) val;

		return (i == 1 || i == 0);
	}
}
