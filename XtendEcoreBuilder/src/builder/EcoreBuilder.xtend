package builder

import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EcoreFactory
import org.eclipse.emf.ecore.EcorePackage

class EcoreBuilder {
	extension EcoreFactory factory = EcoreFactory.eINSTANCE
	extension EcorePackage pck = EcorePackage.eINSTANCE

	def static void main (String[] args) {
		val builder = new EcoreBuilder
		println(builder.dump(builder.buildEcore))
	}
	
	def EPackage buildEcore () {
		createEPackage => [
			name="Tree"
			nsPrefix = "Tree"
			nsURI = "http://eclipse.org/tree"
			
			EClassifiers += createEClass => [
				val nodeType = it
				name = "Node"
				EStructuralFeatures += createEAttribute => [
					name = "label"
					EType = EString
				]
				EStructuralFeatures += createEReference => [
					name = "parent"
					upperBound = 1
					EType = nodeType
				]
				EStructuralFeatures += createEReference => [
					name = "children"
					upperBound = -1
					EType = nodeType
				]
			]
		]
	}
	
	
	def dispatch dump (EPackage it) '''
		EPackage «name» (nsPrefix=«nsPrefix», nsURI=«nsURI»)
		{
			«FOR e: it.EClassifiers»
			«e.dump»
			«ENDFOR»
		}
	'''
	
	def dispatch dump (EClass it) '''
		EClass «name» {
			«FOR e: EStructuralFeatures»
				«e.dump»
			«ENDFOR»
		}
	'''
	
	def dispatch dump (EAttribute it) '''«name»: «EType.name»'''

	def dispatch dump (EReference it) '''
		=> «name»: «EType.name»«IF many»*«ENDIF»
	'''
	
	
}