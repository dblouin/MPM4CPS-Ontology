package org.mpm4cps.owl2latex.wg1deliverables.common;

public class LatexUtils {
	
	private LatexUtils() {
	}
	
	public static Object toLatexURL( final String p_expression ) {
		String translated =  toLatexURL( p_expression, "http://" );
		
		if ( translated.isEmpty() ) {
			translated = p_expression;
		}
		
		String translated2 = toLatexURL( translated, "https://" );
		
		return translated2.isEmpty() ? translated : translated2;
	}

	public static String toLatexURL( 	final String p_expression,
										final String p_delimiter ) {
		final StringBuilder result = new StringBuilder();
		String exprIter = p_expression;
		int indexDelim = exprIter.indexOf( p_delimiter );
		final int delimLength = p_delimiter.length();
		
		while ( indexDelim > -1 ) {
			result.append( exprIter.substring( 0, indexDelim ) );
			result.append( "\\url{" );
			result.append( p_delimiter );
			final int indexEnd = exprIter.substring( indexDelim ).indexOf( ' ' );
			
			if ( indexEnd >= 0 ) {
				result.append( exprIter.substring( indexDelim + delimLength, indexDelim + indexEnd ) );
				exprIter = exprIter.substring( indexEnd );
			}
			else {
				result.append( exprIter.substring( indexDelim + delimLength ) );
				exprIter = "";
			}
			
			result.append( '}' );

			indexDelim = exprIter.indexOf( p_delimiter );
		}
		
		return result.toString();
	}
}
