# httpapi-public-site

Simple httpapi serving public content example site.

# Development

To deploy this project you will need a deployment bucket in the AWS account your using to enable packaging of artifacts.

The make script below requires `STAGE` and `BRANCH` environment variables. Create a `.envrc` file and use [direnv](https://direnv.net/) to switch environments:

```
export S3_BUCKET=lambda-deploy-ap-southeast-2
export AWS_REGION=ap-southeast-2
```

Create your deployment bucket, this only needs to be run once.

```
aws s3 mb $S3_BUCKET
```

To deploy run.

```
make
```

# License

This code was authored by [Mark Wolfe](https://github.com/wolfeidau) and licensed under the [Apache 2.0 license](http://www.apache.org/licenses/LICENSE-2.0).