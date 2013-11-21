function [f] = wKPDF(data, w, dataNew, type)

f = ksdensity(data, dataNew, 'weights', w, 'kernel', type);
