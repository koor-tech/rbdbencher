# rbdbencher

## Usage

You need to have a valid `/etc/ceph/ceph.conf` as the script simply calls out to `rbd` command.

```bash
./rbdbencher.sh
```

**Note**: The script doesn't remove the created test volume(s) when it ends.

### Variables

* `RBD_POOL_NAME`: Name of the rbd pool to use (**Required**).
* `RBD_IMAGE_NAME_PREFIX`: The script creates a volume called `${RBD_IMAGE_NAME_PREFIX}1`, so, e.g., `testimage1` with the default value. Defaults to `testimage`.
* `RBD_IMAGE_SIZE`: Test volume size. Defaults to `10G`.
* `WAIT_AFTER_TEST`: Time in seconds to wait after every `rbd bench` command. Defaults to `7`.

## License

rbdbencher is under the [MIT license](LICENSE).
