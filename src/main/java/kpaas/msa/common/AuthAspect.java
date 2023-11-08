package kpaas.msa.common;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

@Component
@Aspect
public class AuthAspect {

	@Resource(name = "apiProperties")
	private Properties apiProperties;

	@SuppressWarnings("deprecation")
	public Object targetMethod(ProceedingJoinPoint jointPoint) {
	    HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();

		String apiKey = request.getHeader("apiKey");
		String timestamp = request.getHeader("timestamp");

		String apiMasterKey = apiProperties.getProperty("ApiMasterKey");
		String salt = apiProperties.getProperty("ApiKeySalt");
		String makeKey = null;
    	Object result = null;

		if (timestamp != null && !"".equals(timestamp)) {
			MessageDigest md = null;
			try {
				md = MessageDigest.getInstance("SHA-256");
			} catch (NoSuchAlgorithmException e) {
				e.printStackTrace();
			}
			md.update(salt.getBytes());
			md.update(timestamp.getBytes());
			makeKey = String.format("%064x", new BigInteger(1, md.digest()));
		}

		if (apiKey == null || "".equals(apiKey) 
			|| (!apiKey.equals(apiMasterKey)) && !apiKey.equals(makeKey)) {
	        HttpServletResponse response = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getResponse();
	        response.setHeader("Content-Type", "text/plain;charset=UTF-8");
	        response.setStatus(HttpStatus.UNAUTHORIZED.value(), "API key not authorized");
		} else {
	        try {
				result = jointPoint.proceed();
			} catch (Throwable e) {
				e.printStackTrace();
			}
		}

        return result;
    }
}
