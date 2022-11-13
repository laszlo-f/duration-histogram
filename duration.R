#convert brightness versus time bin to on and off blink durations 

args = commandArgs(trailingOnly=TRUE);

file<-args[1];

df<-read.table(file);

threshold<-as.numeric(args[2]);
onlist<-{};
offlist<-{};

offstart<-NA;
onstart<-NA;

if(df$V1[1]<threshold){#first bin off
	onoroff<-0;
} else {#first bin on
	onoroff<-1;
}

for(i in 1:length(df$V1)){
	if(0==onoroff){
		if(df$V1[i]>=threshold){#switch on
			   offlist<-rbind(offlist,i-offstart);
			   onstart<-i;
			   onoroff<-1;
		}
	}else if(1==onoroff){
		if(df$V1[i]<threshold){#switch off
			   onlist<-rbind(onlist,i-onstart);
			   offstart<-i;
			   onoroff<-0;
		}
	} else {
		print('error');
	}
}

write.table(onlist,file=paste('duration/',file,'.',sprintf("%.3f",threshold),'.on',sep=''),row.names=F,col.names=F);
write.table(offlist,file=paste('duration/',file,'.',sprintf("%.3f",threshold),'.off',sep=''),row.names=F,col.names=F);

#make histogram - log time - on
hist<-hist(log(onlist),breaks=8);#time axis is log transformed
brightnesses<-(hist$count/diff(exp(hist$breaks))); #weight counts by bin width
errors<-(sqrt(hist$count+1)/diff(exp(hist$breaks)));  #poisson error estimate



write.table(cbind(hist$mids,brightnesses,errors),file=paste('duration/',file,'.',sprintf("%.3f",threshold),'.on.hist',sep=''),row.names=F,col.names=F);

#make histogram - log time - off
hist<-hist(log(offlist),breaks=8); #time axis is log transformed
brightnesses<-(hist$count/diff(exp(hist$breaks))); #weight counts by bin width
errors<-(sqrt(hist$count+1)/diff(exp(hist$breaks)));  #poisson error estimate


write.table(cbind(hist$mids,brightnesses,errors),file=paste('duration/',file,'.',sprintf("%.3f",threshold),'.off.hist',sep=''),row.names=F,col.names=F);
