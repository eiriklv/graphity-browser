/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package frontend.view.report;

import com.hp.hpl.jena.query.Query;
import com.hp.hpl.jena.query.QueryExecution;
import com.hp.hpl.jena.query.QueryExecutionFactory;
import com.hp.hpl.jena.query.QueryFactory;
import com.hp.hpl.jena.query.QuerySolution;
import com.hp.hpl.jena.query.ResultSet;
import com.hp.hpl.jena.query.Syntax;
import frontend.controller.form.ChartForm;
import frontend.controller.resource.report.ReportResource;
import frontend.view.FrontEndView;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Iterator;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import view.QueryStringBuilder;
import view.QueryXMLResult;

/**
 *
 * @author Pumba
 */
public class ReportReadView extends FrontEndView
{

    public ReportReadView(ReportResource resource)
    {
	super(resource);
    }

    @Override
    public void display(HttpServletRequest request, HttpServletResponse response) throws IOException, TransformerException, ParserConfigurationException
    {
	setStyleSheet(new File(getController().getServletConfig().getServletContext().getRealPath("/xslt/report/ReportReadView.xsl")));

	setQueryResult(request, response);
	
	super.display(request, response);

	response.setStatus(HttpServletResponse.SC_OK);    
    }
    
    private void setQueryResult(HttpServletRequest request, HttpServletResponse response) throws FileNotFoundException, IOException
    {
	String queryString = null;
	if (request.getParameter("query-string") != null) queryString = request.getParameter("query-string");
	else queryString = QueryStringBuilder.build(getController().getServletConfig().getServletContext().getRealPath("/sparql/companiesByRevenue.rq"));
	
	String results = QueryXMLResult.queryRemote("http://dbpedia.org/sparql", queryString);

	setDocument(results);

	getTransformer().setParameter("query-string", queryString);
	getTransformer().setParameter("query-result", true);

	getResolver().setArgument("results", results);
    }
}
