/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.graphity.analytics;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.core.Response;

/**
 *
 * @author Pumba
 */
@Path("/{path}")
public class Resource
{
    @GET
    public Response html()
    {
	return View.build();
    }
}
