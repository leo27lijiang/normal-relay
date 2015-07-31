package com.lefu.normalrelay;

import java.io.File;
import java.io.FileFilter;

import com.linkedin.databus.container.netty.HttpRelay;
import com.linkedin.databus2.relay.DatabusRelayMain;
import com.linkedin.databus2.relay.config.PhysicalSourceStaticConfig;

public class NormalRelay {
	
	public NormalRelay() {
		
	}
	
	/**
	 * @param args
	 * @throws Exception 
	 */
	public static void main(String[] args) throws Exception {
		File confDir = new File("conf");
		if (!confDir.exists() || confDir.isFile()) {
			throw new RuntimeException("Directory conf/ not found");
		}
		File[] files = confDir.listFiles(new FileFilter() {

			@Override
			public boolean accept(File pathname) {
				return pathname.getName().toLowerCase().endsWith(".json");
			}
			
		});
		if (files.length == 0) {
			throw new RuntimeException("No source config found");
		}
		String[] confs = new String[files.length];
		for (int i = 0; i < files.length; i++) {
			confs[i] = files[i].getAbsolutePath();
		}
		HttpRelay.Cli cli = new HttpRelay.Cli();
		cli.setDefaultPhysicalSrcConfigFiles(confs);
		cli.processCommandLineArgs(args);
		cli.parseRelayConfig();
		PhysicalSourceStaticConfig[] pStaticConfigs = cli.getPhysicalSourceStaticConfigs();
	    HttpRelay.StaticConfig staticConfig = cli.getRelayConfigBuilder().build();
	    
	    DatabusRelayMain serverContainer = new DatabusRelayMain(staticConfig, pStaticConfigs);
	    serverContainer.initProducers();
	    serverContainer.registerShutdownHook();
	    serverContainer.startAndBlock();
	}

}
