{ self, inputs, ... }: {
	
	perSystem = { pkgs, ... }: {
		
		packages.myQs = inputs.wrapper-modules.wrappers.quickshell.wrap {};
	};
} 
