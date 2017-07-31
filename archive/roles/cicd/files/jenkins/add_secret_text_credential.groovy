import static java.util.UUID.randomUUID
import jenkins.model.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.plugins.credentials.impl.*
import org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl;
import hudson.util.Secret;

uuid = randomUUID() as String

println uuid

domain = Domain.global()
store = Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

StringCredentialsImpl c = new StringCredentialsImpl(CredentialsScope.GLOBAL, uuid, "Sample Credential Description", Secret.fromString("s3cr3t"));

store.addCredentials(domain, c)