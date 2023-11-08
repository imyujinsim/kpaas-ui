package kpaas.msa.common;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Timestamp;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.http.Header;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpDelete;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.impl.client.LaxRedirectStrategy;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

@Component("restClient")
public class RestClient {
	
	@Resource(name = "apiProperties")
	private Properties apiProperties;
	
	// need to import
	private final RestTemplate restTemplate;

   @Autowired
   public RestClient(RestTemplate restTemplate) {
      this.restTemplate = restTemplate;
   }

	public Map<String, Object> get(String url, Map<String, String> headerMap, Map<String, String> paramMap) throws Exception {
		
		HttpHeaders headers = new HttpHeaders();
		Set<String> keySet = paramMap.keySet();
		Iterator<String> it = keySet.iterator();
		StringBuffer paramStringBf = new StringBuffer();
		
		while(it.hasNext()) {
			String key = it.next();
			paramStringBf.append(key);
			paramStringBf.append("=");
			paramStringBf.append(paramMap.get(key));
			paramStringBf.append("&");
		}
		String paramString = paramStringBf.toString();
		if(!"".equals(paramString)) {
			paramString = "?" + paramString.substring(0, paramString.length() -1);
		}
		
		keySet = headerMap.keySet();
		it = keySet.iterator();
		
		// 암호화 키 추가
		String timestamp = new Timestamp(System.currentTimeMillis()).toString();
		String apiKey = makeKey(timestamp);
		
		while(it.hasNext()) {
			String key = it.next();
			headers.add(key, headerMap.get(key));
		}
		
        headers.add("apiKey", apiKey);
        headers.add("Content-Type", "application/json;charset=UTF-8");
        headers.add("timestamp", timestamp);
        HttpEntity<Object> requestEntity = new HttpEntity<>(paramMap, headers);
        ResponseEntity<Map> resEntity = restTemplate.exchange(url + paramString, HttpMethod.GET, requestEntity, Map.class);
		
		return resEntity.getBody();
	}
	
	public Map<String, Object> post(String url, Map<String, String> headerMap, Map<String, String> paramMap) throws Exception {
		 
        //get 메서드와 URL 설정
		HttpHeaders headers = new HttpHeaders();
        Map<String, Object> result = null;
        
        try {
        	
	        Set<String> keySet = headerMap.keySet();
	        Iterator<String> it = keySet.iterator();
	        
	        // 암호화 키 추가
	        String timestamp = new Timestamp(System.currentTimeMillis()).toString();
	        String apiKey = makeKey(timestamp);
	
	        while(it.hasNext()) {
	        	String key = it.next();
	        	headers.add(key, headerMap.get(key));
	        }
	        
	        headers.add("apiKey", apiKey);
	        headers.add("Content-Type", "application/json;charset=UTF-8");
	        headers.add("timestamp", timestamp);
	        HttpEntity<Object> requestEntity = new HttpEntity<>(paramMap, headers);
	        ResponseEntity<Map> resEntity = restTemplate.exchange(url , HttpMethod.POST, requestEntity, Map.class);
			
	        result = resEntity.getBody();
	        
        } catch (Exception e) {
        	throw e;
        }
        return result;
	}
	
	public Map<String, Object> put(String url, Map<String, String> headerMap, Map<String, String> paramMap) throws Exception {
		 
        //get 메서드와 URL 설정
		HttpHeaders headers = new HttpHeaders();
        Map<String, Object> result = null;
        
        try {
        	
	        Set<String> keySet = headerMap.keySet();
	        Iterator<String> it = keySet.iterator();
	        
	        // 암호화 키 추가
	        String timestamp = new Timestamp(System.currentTimeMillis()).toString();
	        String apiKey = makeKey(timestamp);
	
	        while(it.hasNext()) {
	        	String key = it.next();
	        	headers.add(key, headerMap.get(key));
	        }
	        
	        headers.add("apiKey", apiKey);
	        headers.add("Content-Type", "application/json;charset=UTF-8");
	        headers.add("timestamp", timestamp);
	        HttpEntity<Object> requestEntity = new HttpEntity<>(paramMap, headers);
	        ResponseEntity<Map> resEntity = restTemplate.exchange(url , HttpMethod.PUT, requestEntity, Map.class);
			
	        result = resEntity.getBody();
	        
        } catch (Exception e) {
        	throw e;
        }
        return result;
	}
	
	public Map<String, Object> delete(String url, Map<String, String> headerMap) throws Exception {
		 
        //get 메서드와 URL 설정
		HttpHeaders headers = new HttpHeaders();
        Map<String, Object> result = null;
        
        try {
	        Set<String> keySet = headerMap.keySet();
	        Iterator<String> it = keySet.iterator();
	        
	        // 암호화 키 추가
	        String timestamp = new Timestamp(System.currentTimeMillis()).toString();
	        String apiKey = makeKey(timestamp);
	
	
	        while(it.hasNext()) {
	        	String key = it.next();
	        	headers.add(key, headerMap.get(key));
	        }
	        headers.add("apiKey", apiKey);
	        headers.add("Content-Type", "application/json;charset=UTF-8");
	        headers.add("timestamp", timestamp);
	        HttpEntity<Object> requestEntity = new HttpEntity<>(headers);
	        ResponseEntity<Map> resEntity = restTemplate.exchange(url , HttpMethod.DELETE, requestEntity, Map.class);
			
	        result = resEntity.getBody();
	        
        } catch (Exception e) {
        	throw e;
        }
        
        return result;
	}
	
	private String makeKey(String timestamp) {
		String makeKey = null;
		String salt = apiProperties.getProperty("ApiKeySalt");

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

		return makeKey;
	}
}
