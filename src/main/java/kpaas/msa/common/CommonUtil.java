package kpaas.msa.common;

public class CommonUtil {
	
	public static Object nvl(Object input, Object output) {
		if(input != null)
			output = input;
		return output;
	}

	public static Integer parseInt(String input, Integer output) throws Exception {
		
		try {
			if(input == null) {
				
			} else if (input instanceof String) {
				output = Integer.parseInt(input);
			} else {
				throw new Exception();
			}
		} catch (Exception e) {
			throw new Exception("");
		}
		
		return output;
	}
	
	public static boolean isEmptyString(String input) {
		if(input == null || "".equals(input)) {
			return true;
		}
		return false;
	}
}
