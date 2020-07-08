package org.mpm4cps.owl2latex.wg1deliverables.main;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

import org.eclipse.acceleo.engine.service.AbstractAcceleoGenerator;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.w3._2002._07.owl.Declaration;
import org.w3._2002._07.owl.DocumentRoot;
import org.w3._2002._07.owl.Import;
import org.w3._2002._07.owl.ObjectProperty;
import org.w3._2002._07.owl.Ontology;
import org.w3._2002._07.owl.OwlPackage;
import org.w3._2002._07.owl.SubClassOf;
import org.w3._2002._07.owl.util.OwlResourceFactoryImpl;

public abstract class AbstractOWLAcceleoGenerator extends AbstractAcceleoGenerator {

    @Override
    protected void postInitialize() {
		// Merge the imported ontologies
    	final Ontology rootOntology = getOntology( model );
    	loadImports( rootOntology, new HashSet<String>() );
	}
    
    @SuppressWarnings("unchecked")
	private static void loadImports( 	final Ontology p_ontology,
    									final Set<String> p_processedOntologies ) {
    	for ( final Import importElement : p_ontology.getImport() ) {
    		final Ontology impOntology = getOntology( importElement );
    		p_processedOntologies.add( impOntology.getOntologyIRI() );
			loadImports( impOntology, p_processedOntologies );
			
			makeAbsoluteUris( impOntology );
						
			for ( final EReference ref : impOntology.eClass().getEAllReferences() ) {
				if ( 	ref != OwlPackage.eINSTANCE.getOntology_Import() && ref != OwlPackage.eINSTANCE.getOntology_Annotation() &&
						ref.isContainment() && ref.isMany() && ref.isChangeable() ) {
					( (Collection<EObject>) p_ontology.eGet( ref ) ).addAll( (Collection<EObject>) impOntology.eGet( ref ) );
				}
			}
    	}
    }
    
    private static void makeAbsoluteUris( final Ontology impOntology ) {
		final String packageName = impOntology.getOntologyIRI();
		
		for ( final Declaration decl : impOntology.getDeclaration() ) {
			makeAbsoluteUri( packageName, decl.getClass_() );
			makeAbsoluteUri( packageName, decl.getObjectProperty() );
		}

		for ( final SubClassOf subClassOf : impOntology.getSubClassOf() ) {
			makeAbsoluteUris( packageName, subClassOf.getClass_() );
		}
    }
    
    private static void makeAbsoluteUris( 	final String p_packageName,
    										final  Collection<org.w3._2002._07.owl.Class> p_owlClasses ) {
		for ( final org.w3._2002._07.owl.Class owlClass : p_owlClasses ) {
			makeAbsoluteUri( p_packageName, owlClass );
		}
    }
    
    private static void makeAbsoluteUri( 	final String p_packageName,
    										final org.w3._2002._07.owl.Class p_owlClass ) {
		if ( p_owlClass != null ) {
			final String iri = p_owlClass.getIRI();
			
			if ( !iri.startsWith( p_packageName ) ) {
				p_owlClass.setIRI( p_packageName + iri );
			}
		}
    }
    
    private static void makeAbsoluteUri( 	final String p_packageName,
    										final ObjectProperty p_owlProperty ) {
		if ( p_owlProperty != null ) {
			final String iri = p_owlProperty.getIRI();
			
			if ( !iri.startsWith( p_packageName ) ) {
				p_owlProperty.setIRI( p_packageName + iri );
			}
		}
    }

    private static Ontology getOntology( final Import p_import ) {
		final URI impUri = importedOntologyUri( p_import );
		final Resource res = p_import.eResource().getResourceSet().getResource( impUri, true );
    	
		return getOntology( res );
    }
    
    private static Ontology getOntology( final Resource p_res ) {
    	return getOntology( p_res.getContents().get( 0 ) );
    }
    
    private static Ontology getOntology( final EObject p_content ) {
    	 return ( (DocumentRoot) p_content ).getOntology();
    }

    private static URI importedOntologyUri( final Import p_import ) {
    	final String iri = p_import.getValue();
    	final URI modelUri = p_import.eResource().getURI();
    			
    	// TODO: Eventually read the protege xml lib file
    	final int indexSlash = iri.lastIndexOf( '/' ) + 1;
    	
   		return modelUri.trimSegments( 1 ).appendSegment( iri.substring( indexSlash ) ).appendFileExtension( modelUri.fileExtension() );
    }
    
    /**
     * This can be used to update the resource set's package registry with all needed EPackages.
     * 
     * @param resourceSet
     *            The resource set which registry has to be updated.
     * @generated NOT
     */
    @Override
    public void registerPackages(ResourceSet resourceSet) {
        super.registerPackages(resourceSet);
        
        if (!isInWorkspace( OwlPackage.class )) {
        	
        	// DB: We need to remove the # at the end of the package NS URI imposed by the W3C OWL XSD
            resourceSet.getPackageRegistry().put( OwlPackage.eNS_URI.substring( 0, OwlPackage.eNS_URI.length() - 1 ),OwlPackage.eINSTANCE);
        }
    }

    /**
     * This can be used to update the resource set's resource factory registry with all needed factories.
     * 
     * @param resourceSet
     *            The resource set which registry has to be updated.
     * @generated NOT
     */
    @Override
    public void registerResourceFactories(ResourceSet resourceSet) {
        super.registerResourceFactories(resourceSet);
		
		resourceSet.getResourceFactoryRegistry().getExtensionToFactoryMap().put( "owl", new OwlResourceFactoryImpl() );
    }
}
