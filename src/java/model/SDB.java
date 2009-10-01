/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package model;

import com.hp.hpl.jena.query.Dataset;
import com.hp.hpl.jena.rdf.model.Model;
import com.hp.hpl.jena.sdb.SDBFactory;
import com.hp.hpl.jena.sdb.Store;
import com.hp.hpl.jena.sdb.store.DatasetStore;
import com.hp.hpl.jena.util.FileManager;
import java.io.InputStream;
import javax.servlet.ServletContext;

/**
 *
 * @author Pumba
 */
public class SDB
{
    private static Store store = null;
    private static Dataset dataset = null;

    public static void init(ServletContext context)
    {
	com.hp.hpl.jena.sdb.SDB.getContext().setTrue(com.hp.hpl.jena.sdb.SDB.unionDefaultGraph);
	//com.hp.hpl.jena.sdb.SDB.getContext().setFalse(com.hp.hpl.jena.sdb.SDB.unionDefaultGraph);
	
	store = SDBFactory.connectStore(context.getRealPath("sdb.ttl"));
	dataset = DatasetStore.create(store);
	Model schemaModel = SDBFactory.connectNamedModel(store, "http://temp.com/schema");
	
	String fileName = context.getRealPath("/owl/visualizations.owl");
	InputStream in = FileManager.get().open(fileName);
	if (in == null) throw new IllegalArgumentException("File: " + fileName + " not found");
	schemaModel.read(in, "http://code.google.com/apis/visualization/");
	//schemaModel.write(System.out);
	//System.out.print("Model size: " + schemaModel.size());
	//if (dataset.containsNamedModel("http://temp.com/schema")) System.out.print("CONTAINS");
	//while (dataset.listNames().hasNext())
	    //System.out.print(dataset.listNames());
    }
    
    public static Store getStore()
    {
	return store;
    }

    public static Dataset getDataset()
    {
	return dataset;
    }
    
    public static Model getDefaultModel()
    {
	return getDataset().getDefaultModel();
    }
    
    public static Model getInstanceModel()
    {
	return getDataset().getNamedModel("http://temp.com/instances");
    }
}
