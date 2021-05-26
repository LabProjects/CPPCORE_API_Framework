function fn() {
    var env = karate.env; // get system property 'karate.env'
    karate.log('Get env property from Runner class karate.env system property was:', env);
    if (!env) {
        env = 'dev';
    }
    var config = {
        env: env,
         PayPointBFFBase: '/api/PayPoint/Vend',
         GloudPaymentsPlatformBase: '/payments/sale',
         IVRBase: '/api/IvrPrePay/VendTopUp'
    }

    if (env == 'dev') {
        //config.PayPointEndPoint = 'http://localhost:17001/api/PayPoint/Vend';

    } else if (env == 'GRID') {
        //config.UtilitaEndPoint = 'http://localhost:9080/azp-authzapp/api';

    }else if (env == 'e2e') {
             //config.UtilitaEndPoint = 'http://localhost:9080/azp-authzapp/api';

    }
    else if (env == 'qa') {
        //config.UtilitaEndPoint = 'http://localhost:9080/azp-authzapp/api';

    } else if (env == 'prod') {
         //config.UtilitaEndPoint = 'http://localhost:9080/azp-authzapp/api';
     }
    return config;
}
