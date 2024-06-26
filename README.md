# RP Scripts

RP Scripts automates script execution in Kubernetes. It monitors and automatically executes scripts from newly created `buda.com/rp-scripts` ConfigMaps.

It also provides an Active Admin interface that displays the output from these processed scripts.

## Getting Started

Add this line to your application's Gemfile:

```ruby
gem 'pr-scripts'
```

And then execute:

```bash
$ bundle
```

After that, run the generator:

```bash
$ rails g pr-scripts:install
```
Run the task to wacth over new configmaps:

```bash
$ rake rp:watch
```
### View Script Outputs in the Admin Panel

```
{your_project_url}/admin/rp_scripts_sessions
```
