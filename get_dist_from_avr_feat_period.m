function out =  get_dist_from_avr_feat_period(feat)
% Input:
%   feat   - extracted features of 1 period (31 x 1)
% Output:
%   out    - 
%
% ---------------------------------------------------------
% MIT License 
% Copyright (c) 2021 Anna Ign�cz anna.ignacz95@gmail.com
%
    
    if sum(feat == 0) > 25
        out = 0;
    else

        %means = [0.102869569449834,NaN,0.208586920085762,NaN,NaN,-0.208586920085762,0.146676691729323,NaN,0.459908633734508,NaN,1,NaN,NaN,3.04059490526346,0.0644459455930865,0.0390331093275590,0.0353477305721148,0.0969544816256137,0.0118113863589201,0.000154402507436957,1.12770956906838e-05,0.306790138702990,0.169968500115740,0.311891292747535,0.383451621088670,0.437095543997868,1.10784681081807,2.86104117215631,7.36963479497579,0.0349156728158728,0.0261219619489787,0.174614181685657;0.0874410249172167,NaN,0.178921499608857,NaN,NaN,-0.178921499608857,0.196479353680431,0.288300835654596,0.431289147297983,NaN,1,NaN,NaN,1.55204645805697,0.0509143299108726,0.0368478511290720,0.0428439104911250,0.0499549009738278,0.00711605763382656,0.000279510281684204,2.24438465012005e-06,0.347957182482825,0.250355740995306,0.303962660114294,0.410723559151100,0.461636051505446,0.925309666805366,2.68221695355158,11.5693710069614,0.0274886476688972,0.0298092851175415,0.259508461725223;0.0700115896149699,NaN,0.143993366722605,0.281250650481857,0.270120746886024,-0.0807349856262701,0.286285714285714,0.324163498098860,0.463845492993406,NaN,0.999986230359803,0.682513577937571,0.764871355381489,1.61645006694335,0.0450762404800650,0.0358905358603781,0.0264305066588749,0.0468305290879458,0.00777569583115807,0.000248703046915803,2.57273219342257e-06,0.393328459269716,0.348400129613862,0.288747328811101,0.450391447006697,0.487783017891480,0.563977443464622,2.27999333475692,16.5469109886471,0.0243384988085054,0.0391334555049219,0.348838213313543;0.0771485723942597,0.144610534089237,0.264995646551885,NaN,NaN,-0.264995646551885,0.273518518518518,0.274620689655172,0.248303069628102,0.748516630364283,1,NaN,NaN,1.10246074965186,0.0803967053942000,0.0866141916028698,0.0690385578802805,0.0259474241139028,0.00442579135641560,0.000591531090014660,8.86191079078244e-06,0.413537490667307,0.300490626379523,0.342104288735767,0.616724226184431,0.536027369548220,0.525116765167217,1.80124798507785,11.8012726175184,0.0255448481338962,0.0238014635503908,0.309847529110092];
        %stds = [0.0303392811113325,NaN,0.0413334645238928,NaN,NaN,0.0413334645238928,0.0259087995090999,NaN,0.0516875114625391,NaN,0,NaN,NaN,1.56706687283794,0.0276298489702992,0.0295883524457214,0.0252316817813522,0.0487390903255208,0.00568158002029018,0.000116812426013704,1.18635644258531e-05,0.0592379246042641,0.0798450610002264,0.00862277928733770,0.0984502935887711,0.0480838445049546,0.324304499810192,0.544298030977007,2.30896765149543,0.00619640941528317,0.0385417890065935,0.0302142147530747;0.0248571768164248,NaN,0.0335568992108768,NaN,NaN,0.0335568992108768,0.0639656918576929,0.0974956740158952,0.0687371334447618,NaN,0,NaN,NaN,1.14805408402404,0.0225512109275352,0.0214948247405651,0.0201306721221643,0.0272246421882817,0.00364430349242523,0.000210756297071514,3.15793405885547e-06,0.0522777606083734,0.0757134009451740,0.0243618103905594,0.126880993969789,0.0498728711855044,0.300022746856223,0.750440036722858,2.71468075450180,0.00492557165623614,0.0348708072451335,0.0628309776317342;0.0135919529905353,NaN,0.0324197384329104,0.0544733421694447,0.0258238809766656,0.130866449510179,0.0934339767258909,0.0877360320090461,0.0697243190735684,NaN,0.000333896029932061,0.123919796177637,0.117583696940285,0.701178711377133,0.0178426838958474,0.0167505586405304,0.0142049577073087,0.0176186869803260,0.00273878807080118,0.000149504055042740,5.00025538793244e-06,0.0442678442666698,0.0691541517256933,0.0218071006557514,0.0812173875741438,0.0402883500549373,0.255217191493057,0.409301577238005,3.50069836281045,0.00352805274303384,0.0453313410649031,0.0636680007933216;0.0190084348661403,0.0321266978119116,0.0460779080092428,NaN,NaN,0.0460779080092428,0.0522965927461641,0.0452835619758613,0.0999369703100023,0.100769961276732,0,NaN,NaN,0.643466019867363,0.0416952092417685,0.0161630991471574,0.0115696508478468,0.0151539476930622,0.00192671979906813,0.000599548067203164,1.19299449439799e-05,0.0406438070969450,0.0614709201613208,0.00937054078541601,0.0529909370906212,0.0313780259972264,0.139302138727997,0.154852361706334,1.86821935995090,0.00300319073203485,0.0272643258593597,0.0545479654024733];  

        %stds = stds/2;

        means = [0.102371487588135,0.204523827914477,NaN,NaN,-0.204523827914477,0.147380000000000,NaN,0.461789215706015,1,NaN,NaN,2.89193157877567,0.0624033317946260,0.0386761043751306,0.0355601476769672,0.0904918357957830,0.0112992073033031,0.000166548856668569,1.05435819793394e-05,0.305708732922576,0.167594669199843,0.311134559873635,0.381394038187719,0.435522334839013,1.11507435572473,2.85874999746483,7.60878164870346,0.0339453928335334,0.0253536909026642,0.176866464293560;0.0879972184929737,0.179952312905229,NaN,0.486776179563874,0.160038515243410,0.199644230769230,0.287461864406780,0.429304357948536,1,NaN,0.408894292179596,1.47314918479977,0.0507424437139441,0.0383745489884828,0.0444201730877574,0.0489285778781332,0.00704784273671337,0.000284081733728946,2.14639540819154e-06,0.347329203601177,0.246976030614224,0.305974412701149,0.419090355407992,0.462438900518407,0.921431893076685,2.65850205158643,11.4995121111641,0.0273852953953847,0.0257737466792989,0.260640510232697;0.0687352206940620,0.141542457566271,0.276299436651174,0.472741517875823,0.274251838434039,0.289413486005089,0.327219158200290,0.462511133141746,0.999989699047791,0.707770022108974,0.496859082481084,1.58516214005525,0.0440298292549206,0.0363467100640497,0.0256789724481503,0.0452752073755891,0.00760108832018460,0.000237529125361192,2.98388727674747e-06,0.394139451746839,0.348339138741291,0.287971888321997,0.449490962049890,0.487989076010616,0.562845460747979,2.28145302020562,16.9624217138576,0.0239134648287587,0.0405001018948278,0.357093938527854;0.0759040110773336,0.267844160449383,0.143891746960212,0.527477565488849,0.0742117408360598,0.275093333333333,0.277000000000000,0.251461665770139,1,0.744309259509919,0.402606862986695,1.19736007688287,0.0809056052211642,0.0854504405845234,0.0692396805663028,0.0290194277306901,0.00482389480876363,0.000520830269708945,1.10958227521470e-05,0.418882152169166,0.305616818370275,0.343012593678578,0.624218208129770,0.540695581847707,0.508250925284375,1.77639353414287,11.6970869503145,0.0264078822788200,0.0258458336569567,0.312099432419983];
        stds = [0.0280054127388860,0.0336123605904815,NaN,NaN,0.0336123605904815,0.0262622185011666,NaN,0.0515783692402939,0,NaN,NaN,1.61593083466188,0.0214862253131988,0.0287723986212280,0.0235063371506809,0.0488602107087586,0.00579481082548866,0.000150633106893037,1.11855725284951e-05,0.0509941077987319,0.0669725324609669,0.00888551332166901,0.0935827511465831,0.0412482032457763,0.285643183093136,0.518871304651078,2.36186695406680,0.00597701296433012,0.0308930717375751,0.0303727804962491;0.0234507675819345,0.0321473849302060,NaN,0.0951825845167008,0.273278557269804,0.0663071803615226,0.0946252785511899,0.0681308722558279,0,NaN,0.142156596558797,1.03898863468180,0.0225072057121707,0.0219283723002070,0.0197188166017142,0.0272068567089528,0.00370922949954732,0.000226030434316648,3.15238497674518e-06,0.0523181566117075,0.0725974829290891,0.0245405682125160,0.129959004562266,0.0503979642473591,0.297689007848805,0.761409268491828,2.70920531725998,0.00490591835328339,0.0298734164119505,0.0632293522374413;0.0121201673338456,0.0317544468835204,0.0501291554513700,0.0715403838322824,0.179545761606972,0.0937212469167397,0.0902899713963598,0.0647702885920180,0.000288794318667954,0.130769680316895,0.133531260510190,0.703335076025833,0.0169308333021901,0.0175400583865368,0.0142800781367078,0.0167166091285399,0.00276191777282181,0.000135702649977571,2.11652803596217e-05,0.0432028313080333,0.0650740765498201,0.0238850407438086,0.0847507548732206,0.0405106973530021,0.247880733790276,0.435623648122642,3.62320315426537,0.00320781501086411,0.0432100605411497,0.0648634989402472;0.0182087037650068,0.0454697212523175,0.0341341652364372,0.0935391427695828,0.259871875508419,0.0478672639175768,0.0518755218522364,0.0983891606587480,0,0.0994740610428486,0.0848649714437679,0.551024424878191,0.0420091169325367,0.0166932652354856,0.0112833809874949,0.0142067285755948,0.00188917461740138,0.000548410962159834,1.69181116814406e-05,0.0386297159796628,0.0579203605600383,0.00923184533573107,0.0522478872394107,0.0291162390925491,0.126754692418751,0.141025327257137,1.69058253257246,0.00300787879841646,0.0279063934144476,0.0502083229433229];
        stds = stds / 2;
        Feat_diff = feat;
        i = feat(31); 
        Feat_diff(:,1:30) = max(0,abs(Feat_diff(:,1:30) - means(i,:))./stds(i,:)-2);

        Feat_diff_norm = Feat_diff;
        Feat_diff_norm(:,1:30) = 5-(abs(Feat_diff_norm(:,1:30)));
        Feat_diff_norm(Feat_diff_norm < 0) = 0;

        %coefs = [0.29,0.08,0.26,0.06,0.21,0.31,0.21,0.33,0.29,0.11,0.11,0.05,0.14,0.33,0.30,0.27,0.23,0.23,0.28,0.13,0.13,0.39,0.39,0.31,0.26,0.36,0.39,0.24,0.29,0.32,0.58,0.29];
        coefs = [0.40,0.34,0.31,0.37,0.18,0.26,0.31,0.36,0.16,0.19,0.29,0.38,0.41,0.29,0.28,0.31,0.36,0.19,0.07,0.53,0.56,0.38,0.32,0.48,0.54,0.21,0.35,0.40,0.64,0.36];

        %ind = [2, 4, 5, 7, 10, 11, 12, 13, 17, 18, 20, 21, 28];
        ind = [5,6,9,10,11,14,15,18,19,26];

        coefst = coefs.^2;
        coefst(ind) = 0;

        out = sum((coefst./sum(coefst)).*Feat_diff_norm(:,1:30),2,'omitnan');

    end
end