package xyz.navira.web;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.json.simple.JSONValue;

import xyz.navira.fworks.DataFile;
import xyz.navira.fworks.DataStore;

/**
 * Servlet implementation class Index
 */
@WebServlet("/")
public class Index extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private DataStore dataStore; 

    /**
     * Default constructor. 
     */
    public Index() {
        try {
			dataStore = new DataStore();
		} catch (Exception e) {			
			e.printStackTrace();
		}
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {		
		if("true".equals(request.getParameter("delete"))) {
			String key = request.getParameter("key");
			dataStore.deleteDataFile(key);
			try { dataStore = new DataStore(); } catch (Exception e) {e.printStackTrace();}
		}
		else if("true".equals(request.getParameter("add"))) {
			String key = request.getParameter("key");
			String ttl = request.getParameter("ttl");
			String value = request.getParameter("value");
			JSONObject json = new JSONObject();
			try {
				json = (JSONObject) JSONValue.parse(value);
			}
			catch(Exception e) {
				request.setAttribute("error", "Invalid JSON format");
			}
			try {
				if(ttl == null || "".equals(ttl)) ttl = "-1";
				DataFile dF = dataStore.createDataFile(key, Integer.parseInt(ttl));
				dF.putContent(json);
			}
			catch(Exception e) {
				request.setAttribute("error", "Key already exists");
			}
			
		}
		request.setAttribute("datastore", dataStore);
		request.getRequestDispatcher("WEB-INF/index.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
